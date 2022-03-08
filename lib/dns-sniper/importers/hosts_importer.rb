# frozen_string_literal: true

module DNSSniper
  class HostsImporter < Importer
    def import_file(path, *)
      return [] unless File.exist?(path)

      HostsFile.load(path).map(&:name).map { |hostname| clean(hostname) }.reject { |hostname| rejector(hostname) }
    end

    def import_uri(uri, options = {})
      data = ConditionalFetch.new(uri, options).data || ''

      arr = []
      domains = HostsFile::Parser.new(data)
      domains.each { |domain| arr << domain.name }

      arr
    end
  end
end
