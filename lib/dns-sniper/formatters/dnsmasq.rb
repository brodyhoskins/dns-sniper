module DNSSniper
  class Dnsmasq < Formatter
    def initialize(hostnames, options = {})
      @hostnames = hostnames
      @options = options
    end

    def output(options = {})
      str = ""
      @hostnames.each do |hostname|
        str << "server=/#{hostname}/#{$/}"
      end
      str
    end
  end
end
