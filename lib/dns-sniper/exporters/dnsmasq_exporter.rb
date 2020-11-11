# frozen_string_literal: true

module DNSSniper
  class DnsmasqExporter < Exporter
    def output(*)
      str = ''.dup
      @hostnames.each do |hostname|
        str << "server=/#{hostname}/#{$/}"
      end
      str
    end
  end
end
