require "down"
require "hosts_file"
require "open-uri"
require "resolv"

module Sniper
  class Hostnames
    def initialize(options = {})
      @hostnames = [].to_set
      self
    end

    def add(hostname)
      hostname = clean(hostname)
      @hostnames << hostname if hostname
      self
    end

    def add_many(hostnames)
      hostnames.each { |hostname| add(hostname) }
      self
    end

    def add_from(paths_or_urls)
      return self unless paths_or_urls
      if (paths_or_urls.class == String)
        paths_or_urls = [paths_or_urls]
      end

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
            STDERR.puts "\"#{path_or_url}\" does not exist"
            return self
          rescue Down::ResponseError
            STDERR.puts "\"#{path_or_url}\": No data from server"
            return self
          end
        end

        case syntax(path_or_url, contents)
        when nil
          STDERR.puts "Error: Syntax: Syntax of \"#{path_or_url}\" not recognized, ignored"
          return self
        when "hosts"
          add_many from_hosts_file(path_or_url)
        when "hostnames"
          add_many from_hostnames_file(contents)
        end
      end

      self
    end

    def remove(hostname)
      hostname = clean(hostname)
      @hostnames = @hostnames - [hostname] if hostname
      self
    end

    def remove_many(hostnames)
      hostnames.each { |hostname| remove(hostname) }
      self
    end

    def remove_from(paths_or_urls)
      return self unless paths_or_urls
      if (paths_or_urls.class == String)
        paths_or_urls = [paths_or_urls]
      end

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
            STDERR.puts "\"#{path_or_url}\" does not exist"
            return self
          rescue Down::ResponseError
            STDERR.puts "\"#{path_or_url}\": No data from server"
            return self
          end
        end

        case syntax(path_or_url, contents)
        when nil
          STDERR.puts "Error: Syntax: Syntax of \"#{path_or_url}\" not recognized, ignored"
          return self
        when "hosts"
          remove_many from_hosts_file(path_or_url)
        when "hostnames"
          remove_many from_hostnames_file(contents)
        end
      end

      self
    end

    def to_format(format)
      format = format.capitalize
      begin
        klass = Sniper.const_get(format)
        klass.new(@hostnames.to_a).output
      rescue NameError
        return false
      end
    end

    def to_a
      @hostnames.to_a
    end

    def to_text
      @hostnames.to_a.join("\n")
    end

    def to_unbound
      str = "server:\n"
      @hostnames.each do |hostname|
        str << "  local-zone: \"#{hostname}\" static\n"
      end
      str
    end

    private

    def clean(hostname)
      hostname = hostname.downcase.strip
      hostname = hostname.sub("www.", "")
      hostname_top_domain = "#{hostname.split(".")[-2]}.#{hostname.split(".")[-1]}"

      if not hostname.include?("#") and not ["broadcasthost", "localhost", ""].include?(hostname) and not @hostnames.include?(hostname_top_domain)
        hostname
      else
        nil
      end
    end

    def syntax(path_or_url, contents)
      contents.each do |line|
        next if line.include?("#")
        line = line.downcase

        if line.strip.split(/\s/).first =~ Regexp.union([Resolv::IPv4::Regex, Resolv::IPv6::Regex])
          return "hosts"
        elsif line.include? "." and not line.include? "http" and path_or_url.end_with?(".list")
          return "hostnames"
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
