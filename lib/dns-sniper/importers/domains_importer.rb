# frozen_string_literal: true

module DNSSniper
  class DomainsImporter < Importer
    def import_file(path, *)
      return [] unless File.exist?(path)

      File.open(path).readlines(chomp: true).map { |hostname| clean(hostname) }.reject { |hostname| rejector(hostname) }
    end

    def import_uri(uri, options = {})
      data = ConditionalFetch.new(uri, options).data
      return [] unless data

      data.split(/\n+|\r+/).reject(&:empty?)
    end
  end
end
