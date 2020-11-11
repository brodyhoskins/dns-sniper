# frozen_string_literal: true

module DNSSniper
  class NetgearExporter < Exporter
    def output(*)
      str = ''.dup
      @hostnames.each_with_index do |hostname, i|
        str << "[517003_e]: #{i + 1}) #{hostname}\n"
      end
      str
    end
  end
end
