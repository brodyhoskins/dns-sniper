module Sniper
  class Text < Formatter
    def initialize(hostnames, options = {})
      @hostnames = hostnames
      @options = options
    end

    def output
      @hostnames.to_a.join($/)
    end
  end
end
