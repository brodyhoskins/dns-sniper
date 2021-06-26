# frozen_string_literal: true

require 'down'
require 'hosts_file'
require 'open-uri'
require 'resolv'

module DNSSniper
  class Hostnames
    attr_accessor :blacklist
    attr_accessor :whitelist

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
