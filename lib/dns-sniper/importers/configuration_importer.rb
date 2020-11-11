# frozen_string_literal: true

module DNSSniper
  class ConfigurationImporter < Importer
    def initialize(uri, list:)
      @uri = uri
      @hostnames = File.exist?(uri) ? import_file(uri, list: list) : import_uri(uri, list: list)
    end

    def import_file(path, list:)
      raise ArgumentError, "#{self.class.name}: #from_path requies list to be defined" unless list
      return [].to_set unless File.exist?(path)

      yaml = YAML.safe_load(File.read(path), permitted_classes: [Symbol])
      return [].to_set unless yaml.dig(:sources)&.dig(list.to_sym)

      hostnames = [].to_set
      yaml.dig(:sources).dig(list.to_sym).each do |source|
        return [].to_set unless source.dig(:importer)
        return [].to_set unless source.dig(:uri)

        importer = DNSSniper.const_get("#{source.dig(:importer).to_s.split('_').map(&:capitalize).join}Importer")
        if !importer
          next
        else
          importer = importer.new(source.dig(:uri))
          hostnames += importer.hostnames
        end
      end

      hostnames
    end

    def import_uri(_uri, list:)
      raise NotImplementedError, "#{self.class.name}: #from_uri not supported"
    end
  end
end
