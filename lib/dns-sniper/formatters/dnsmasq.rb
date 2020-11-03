# frozen_string_literal: true

module DNSSniper
  class Dnsmasq < Formatter
    def initialize(hostnames, options = {})
      @hostnames = hostnames
      @options = options
    end

    def output(_options = {})
      str = ''.dup
      @hostnames.each do |hostname|
        str << "server=/#{hostname}/#{$/}"
      end
      str
    end
  end
end
