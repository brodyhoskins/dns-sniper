# frozen_string_literal: true

module DNSSniper
  module Exporters
    module_function

    attr_reader :registered
    @registered = []

    def register(class_name, autoload_require)
      DNSSniper.autoload(class_name, autoload_require)
      @registered << class_name
    end

    def all
      @registered.map { |name| DNSSniper.const_get(name) }
    end

    def find(name)
      all.find { |c| c.name.downcase == name.to_s.downcase } or raise NameError, "Unknown exporter \"#{name}\""
    end
  end
end

DNSSniper::Exporters.register :Bind8Exporter, 'dns-sniper/exporters/bind8_exporter'
DNSSniper::Exporters.register :DnsmasqExporter, 'dns-sniper/exporters/dnsmasq_exporter'
DNSSniper::Exporters.register :HostsExporter, 'dns-sniper/exporters/hosts_exporter'
DNSSniper::Exporters.register :NetgearExporter, 'dns-sniper/exporters/netgear_exporter'
DNSSniper::Exporters.register :TextExporter, 'dns-sniper/exporters/text_exporter'
DNSSniper::Exporters.register :UnboundExporter, 'dns-sniper/exporters/unbound_exporter'
