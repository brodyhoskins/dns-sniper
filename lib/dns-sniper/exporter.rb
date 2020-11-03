# frozen_string_literal: true

module DNSSniper
  class Exporter
    def initialize(hostnames)
      @hostnames = hostnames
    end

    def output
      raise NotImplementedError, "Error: #output isn’t supported by #{self.class.name}"
    end
  end
end
