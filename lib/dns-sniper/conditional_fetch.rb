# frozen_string_literal: true

module DNSSniper
  class ConditionalFetch
    attr_reader :data, :headers, :response

    def initialize(uri, options = {})
      @options = options
      @uri = uri
      @uri = CGI.escape_html(@uri).to_s
      @uri = URI.parse(@uri)

      @data = nil
      @headers = nil
      @response = nil

      fetch
    end

    # Headers

    def etag
      @etag ||= @headers&.dig('etag')
    end

    def expires_at
      @expires_at ||= !date || !max_age ? nil : (date + max_age)
    end

    private

    def fetch
      last_etag = @options[:last_etag]
      last_updated_at = @options[:last_updated_at]

      http = Net::HTTP.new(@uri.host, @uri.port)
      http.use_ssl = true if @uri.instance_of?(URI::HTTPS)

      if @options[:last_updated_at] || @options[:last_etag]
        response = http.head(@uri.request_uri)
        if response.is_a?(Net::HTTPSuccess)
          @headers = response&.each_header.to_h
          @response = response
          @data = response&.body

          return self unless update?
        end
      end

      request = Net::HTTP::Get.new(@uri.request_uri)
      response = http.request(request)

      @headers = response.each_header&.to_h
      @response = response
      @data = response&.body

      self
    end

    def update?
      last_etag = @options[:last_etag]
      last_updated_at = @options[:last_updated_at]

      return last_etag != etag if last_etag && etag && etag.strip != ''

      if last_updated_at && created_at
        if max_age
          return (last_updated_at + max_age) < created_at
        elsif age
          return (last_updated_at + age) < created_at
        else
          return last_updated_at < created_at
        end
      end

      true
    end

    # Headers

    def age
      @age ||= @headers&.dig('age')&.to_i
    end

    def cache_control
      return @cache_control if @cache_control

      header = @headers&.dig('cache-control')
      @cache_control = if !header || !header.include?('max-age=')
                         nil
                       else
                         header
                       end
    end

    def created_at
      !date || !age ? nil : (date - age)
    end

    def date
      return @date if @date

      date = @headers&.dig('date')
      @date = date ? Time.rfc2822(date) : nil
    end

    def max_age
      @max_age ||= cache_control ? cache_control.split('=')[1]&.to_i : nil
    end
  end
end
