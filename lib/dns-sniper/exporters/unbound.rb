# frozen_string_literal: true

module DNSSniper
  class Unbound < Exporter
    def initialize(hostnames, options = {})
      @hostnames = hostnames
      @options = options
    end

    def output(_options = {})
      str = ''.dup
      str << "server:#{$/}"
      @hostnames.each do |hostname|
        str << "  local-zone: \"#{hostname}\" static#{$/}"
      end
      str
    end
  end
end
