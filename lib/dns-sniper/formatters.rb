module DNSSniper
  module Formatters
    extend self

    attr_reader :registered
    @registered = []

    def register(class_name, autoload_require)
      DNSSniper.autoload(class_name, autoload_require)
      self.registered << class_name
    end

    def all
      DNSSniper::Formatters.registered.map { |name| DNSSniper.const_get(name) }
    end

    def find(name)
      all.find { |c| c.name.downcase == name.to_s.downcase } or raise NameError, "unknown carrier #{name}"
    end
  end
end

DNSSniper::Formatters.register :Bind8, "dns-sniper/formatters/bind8"
DNSSniper::Formatters.register :Dnsmasq, "dns-sniper/formatters/dnsmasq"
DNSSniper::Formatters.register :Hosts, "dns-sniper/formatters/hosts"
DNSSniper::Formatters.register :Text, "dns-sniper/formatters/text"
DNSSniper::Formatters.register :Unbound, "dns-sniper/formatters/unbound"
