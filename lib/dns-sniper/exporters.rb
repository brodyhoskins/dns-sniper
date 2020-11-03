# frozen_string_literal: true

module DNSSniper
  module Exporters
    extend self

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

DNSSniper::Exporters.register :Bind8, 'dns-sniper/exporters/bind8'
DNSSniper::Exporters.register :Dnsmasq, 'dns-sniper/exporters/dnsmasq'
DNSSniper::Exporters.register :Hosts, 'dns-sniper/exporters/hosts'
DNSSniper::Exporters.register :Netgear, 'dns-sniper/exporters/netgear'
DNSSniper::Exporters.register :Text, 'dns-sniper/exporters/text'
DNSSniper::Exporters.register :Unbound, 'dns-sniper/exporters/unbound'
