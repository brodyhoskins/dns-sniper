# frozen_string_literal: true

module DNSSniper
  class Text < Exporter
    def initialize(hostnames, options = {})
      @hostnames = hostnames
      @options = options
    end

    def output(_options = {})
      @hostnames.to_a.join($/)
    end
  end
end
