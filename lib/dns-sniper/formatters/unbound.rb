# frozen_string_literal: true

module DNSSniper
  class Unbound < Formatter
    def initialize(hostnames, options = {})
      @hostnames = hostnames
      @options = options
    end

    def output(_options = {})
      str = ''.dup
      str << "server:#{$INPUT_RECORD_SEPARATOR}"
      @hostnames.each do |hostname|
        str << "  local-zone: \"#{hostname}\" static#{$INPUT_RECORD_SEPARATOR}"
      end
      str
    end
  end
end
