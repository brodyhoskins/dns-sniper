module Sniper
  module Formatters
    extend self

    attr_reader :registered
    @registered = []

    def register(class_name, autoload_require)
      Sniper.autoload(class_name, autoload_require)
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

Sniper::Formatters.register :Text, "sniper/formatters/text"
Sniper::Formatters.register :Unbound, "sniper/formatters/unbound"
