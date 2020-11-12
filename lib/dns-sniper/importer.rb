# frozen_string_literal: true

module DNSSniper
  class Importer
    attr_accessor :uri, :hostnames

    def initialize(uri, *)
      @uri = uri
      @hostnames = File.exist?(uri) ? import_file(uri) : import_uri(uri)
    end

    def import_file(*)
      raise NotImplementedError, "#{self.class.name}: #import_file not supported"
    end

    def import_uri(*)
      raise NotImplementedError, "#{self.class.name}: #import_uri not supported"
    end

    # Helper methods

    def clean(domain)
      domain = domain.split('#')[0] if domain[0] != '#' && domain.include?('#')
      domain = domain.split(':')[0] if domain.include?(':') && !ip_addr?(domain)
      domain = domain.sub('www.', '') if domain.start_with?('www.') && domain.scan('www.').count == 1

      domain.chomp.gsub(/\s+/, '').downcase
    end

    def rejector(domain)
      !domain?(domain)
    end

    def domain?(domain)
      return false if domain == ''
      return false if domain.gsub('#', '').gsub(/\s+/, '').empty?
      return false if domain[0] == '#'
      return false unless domain.include?('.')
      return false if domain.include?(':')
      return false if domain.include?('?')
      return false if ip_addr?(domain)
      return false unless /\b((?=[a-z0-9-]{1,63}\.)(xn--)?[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,63}\b/.match?(domain)

      begin
        return false if URI.parse(domain).is_a?(URI::HTTP)
      rescue URI::InvalidURIError; end
      true
    end

    def ip_addr?(domain)
      domain =~ Regexp.union([Resolv::IPv4::Regex, Resolv::IPv6::Regex])
    end
  end
end
