# frozen_string_literal: true

module DNSSniper
  class HostsImporter < Importer
    def import_file(path, *)
      return [] unless File.exist?(path)

      HostsFile.load(path).map(&:name).map { |hostname| clean(hostname) }.reject { |hostname| rejector(hostname) }
    end

    def import_uri(uri, *)
      begin
        down = Down.download(uri)
        path = down.path
      rescue Down::InvalidUrl => e
        warn "#{self.class.name}: #{e}"
      end

      if path
        return HostsFile.load(path).map(&:name).map { |hostname| clean(hostname) }.reject { |hostname| rejector(hostname) }
      end

      []
    end
  end
end
