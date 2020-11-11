# frozen_string_literal: true

module DNSSniper
  class HostsExporter < Exporter
    def output(*)
      str = ''.dup
      @hostnames.each do |hostname|
        str << "127.0.0.1\t#{hostname}#{$/}"
      end
      str
    end
  end
end
