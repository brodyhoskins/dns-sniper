module DNSSniper
  class Hosts < Formatter
    def initialize(hostnames, options = {})
      @hostnames = hostnames
      @options = options
    end

    def output
      str = ""
      @hostnames.each do |hostname|
        str << "127.0.0.1\t#{hostname}#{$/}"
      end
      str
    end
  end
end
