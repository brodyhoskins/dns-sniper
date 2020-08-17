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
      Sniper::Formatters.registered.map { |name| Sniper.const_get(name) }
    end

    def find(name)
      all.find { |c| c.name.downcase == name.to_s.downcase } or raise NameError, "unknown carrier #{name}"
    end
  end
end

DNSSniper::Formatters.register :Dnsmasq, "dns-sniper/formatters/dnsmasq"
DNSSniper::Formatters.register :Text, "dns-sniper/formatters/text"
DNSSniper::Formatters.register :Unbound, "dns-sniper/formatters/unbound"
