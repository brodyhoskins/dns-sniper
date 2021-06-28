# frozen_string_literal: true

module DNSSniper
  class DomainsImporter < Importer
    def import_file(path)
      return [] unless File.exist?(path)

      File.open(path).readlines(chomp: true).map { |hostname| clean(hostname) }.reject { |hostname| rejector(hostname) }
    end

    def import_uri(uri)
      begin
        down = Down.download(uri)
        return down.readlines(chomp: true).map { |hostname| clean(hostname) }.reject { |hostname| rejector(hostname) }
      rescue Down::InvalidUrl => e
        warn "#{self.class.name}: #{e}"
      end

      []
    end
  end
end
