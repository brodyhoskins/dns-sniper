# frozen_string_literal: true

module DNSSniper
  class Hostnames
    attr_accessor :blacklist, :whitelist

    Exporters.all.each do |exporter|
      format = exporter.to_s.split('::').last[..-9].tableize.singularize

      define_method(:"to_#{format}") { exporter.new(blocklist).data }
    end

    def initialize
      @blacklist = []
      @whitelist = []
      self
    end

    def blocklist
      blacklist = @blacklist
      whitelist = @whitelist

      whitelist.each do |domain|
        domain_parts = domain.split('.')
        domain_parts.count.times do |count|
          next if count == 1

          whitelist += [domain_parts[count - 1, domain_parts.length].join('.')]
        end
      end

      blacklist - whitelist
    end
  end
end
