module DNSSniper
  class Netgear < Formatter
    def initialize(hostnames, options = {})
      @hostnames = hostnames
      @options = options
    end

    def output(options = {})
      str = ""
      @hostnames.each_with_index do |hostname, i|
        str << "[517003_e]: #{i + 1}) #{hostname}\n"
      end
      str
    end
  end
end
