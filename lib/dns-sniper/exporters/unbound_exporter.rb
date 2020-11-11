# frozen_string_literal: true

module DNSSniper
  class UnboundExporter < Exporter
    def output(*)
      str = ''.dup
      str << "server:#{$/}"
      @hostnames.each do |hostname|
        str << "  local-zone: \"#{hostname}\" static#{$/}"
      end
      str
    end
  end
end
