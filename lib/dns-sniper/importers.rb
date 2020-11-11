# frozen_string_literal: true

module DNSSniper
  module Importers
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
      all.find { |c| c.name.downcase == name.to_s.downcase } or raise NameError, "Unknown Importer \"#{name}\""
    end
  end
end

DNSSniper::Importers.register :ConfigurationImporter, 'dns-sniper/importers/configuration_importer'
DNSSniper::Importers.register :DomainsImporter, 'dns-sniper/importers/domains_importer'
DNSSniper::Importers.register :HostsImporter, 'dns-sniper/importers/hosts_importer'
