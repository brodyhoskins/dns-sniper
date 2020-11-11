# frozen_string_literal: true

module DNSSniper
  class TextExporter < Exporter
    def output(_options = {})
      @hostnames.to_a.join($/)
    end
  end
end
