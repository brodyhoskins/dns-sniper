module DNSSniper
  class Unbound < Formatter
    def initialize(hostnames, options = {})
      @hostnames = hostnames
      @options = options
    end

    def output
      str = "server:#{$/}"
      @hostnames.each do |hostname|
        str << "  local-zone: \"#{hostname}\" static#{$/}"
      end
      str
    end
  end
end
