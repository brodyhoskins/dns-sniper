# frozen_string_literal: true

module DNSSniper
  class Exporter
    attr_accessor :data, :hostnames

    def initialize(hostnames, options = {})
      @hostnames = hostnames
      @data = output(options)
    end

    def output(*)
      raise NotImplementedError, "Error: #output isn’t supported by #{self.class.name}"
    end
  end
end
