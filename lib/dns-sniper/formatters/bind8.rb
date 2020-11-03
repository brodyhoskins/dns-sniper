# frozen_string_literal: true

module DNSSniper
  class Bind8 < Formatter
    def initialize(hostnames, options = {})
      @hostnames = hostnames
      @options = options
    end

    def output(options = {})
      raise ArgumentError, 'zone_file is required' unless defined?(options[:zone_file])

      str = ''.dup
      @hostnames.each do |hostname|
        str << "zone \"#{hostname}\" { type master; notify no; file \"#{options[:zone_file]}\"; };#{$/}"
      end
      str
    end
  end
end
