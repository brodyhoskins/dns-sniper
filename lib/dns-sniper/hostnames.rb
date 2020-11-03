# frozen_string_literal: true

require 'down'
require 'hosts_file'
require 'open-uri'
require 'resolv'

module DNSSniper
  class Hostnames
    def initialize(_options = {})
      @hostnames = [].to_set
      self
    end

    def add(hostnames)
      hostnames = clean(hostnames.class == String ? [hostnames] : hostnames)
      @hostnames += hostnames unless hostnames.empty?
      self
    end

    def add_from(paths_or_urls)
      return self unless paths_or_urls

      paths_or_urls = [paths_or_urls] if paths_or_urls.class == String

      paths_or_urls.each do |path_or_url|
        path_or_url = path_or_url.strip

        if File.exist?(path_or_url)
          contents = File.open(path_or_url).readlines(chomp: true)
        else
          begin
            down = Down.download(path_or_url)
            path_or_url = down.path
            contents = down.readlines(chomp: true)
          rescue Down::NotFound
            warn "\"#{path_or_url}\" does not exist"
            return self
          rescue Down::ResponseError
            warn "\"#{path_or_url}\": No data from server"
            return self
          end
        end

        case syntax(path_or_url, contents)
        when nil
          warn "Error: Syntax: Syntax of \"#{path_or_url}\" not recognized, ignored"
          return self
        when 'hosts'
          add from_hosts_file(path_or_url)
        when 'hostnames'
          add from_hostnames_file(contents)
        end
      end

      self
    end

    def remove(hostnames)
      hostnames = clean(hostnames.class == String ? [hostnames] : hostnames)
      @hostnames -= hostnames unless hostnames.empty?
      self
    end

    def remove_from(paths_or_urls)
      return self unless paths_or_urls

      paths_or_urls = [paths_or_urls] if paths_or_urls.class == String

      paths_or_urls.each do |path_or_url|
        path_or_url = path_or_url.strip

        if File.exist?(path_or_url)
          contents = File.open(path_or_url).readlines
        else
          begin
            down = Down.download(path_or_url)
            path_or_url = down.path
            contents = down.readlines
          rescue Down::NotFound
            warn "\"#{path_or_url}\" does not exist"
            return self
          rescue Down::ResponseError
            warn "\"#{path_or_url}\": No data from server"
            return self
          end
        end

        case syntax(path_or_url, contents)
        when nil
          warn "Error: Syntax: Syntax of \"#{path_or_url}\" not recognized, ignored"
          return self
        when 'hosts'
          remove from_hosts_file(path_or_url)
        when 'hostnames'
          remove from_hostnames_file(contents)
        end
      end

      self
    end

    def to_format(format, options = {})
      format = format.capitalize
      begin
        klass = DNSSniper.const_get(format)
        klass.new(@hostnames.to_a).output(options)
      rescue NameError
        false
      end
    end

    def to_a
      @hostnames.to_a
    end

    private

    def clean(hostnames)
      cleaned_hostnames = []
      hostnames.each do |hostname|
        hostname = hostname.downcase.strip
        hostname = hostname.sub('www.', '')
        hostname_top_domain = "#{hostname.split('.')[-2]}.#{hostname.split('.')[-1]}"

        if !hostname.include?('#') && !['broadcasthost', 'localhost', ''].include?(hostname) && !@hostnames.include?(hostname_top_domain)
          cleaned_hostnames << hostname
        end
      end
      cleaned_hostnames
    end

    def syntax(path_or_url, contents)
      contents.each do |line|
        next if line.include?('#')

        line = line.downcase

        if line.strip.split(/\s/).first =~ Regexp.union([Resolv::IPv4::Regex, Resolv::IPv6::Regex])
          return 'hosts'
        elsif line.include?('.') && (!line.include? 'http') && path_or_url.end_with?('.list')
          return 'hostnames'
        end
      end
      nil
    end

    def from_hosts_file(path_or_url)
      # TODO: Remove downloading file twice
      HostsFile.load(path_or_url).map(&:name)
    end

    def from_hostnames_file(contents)
      contents.each { |line| add(line) }
    end
  end
end
