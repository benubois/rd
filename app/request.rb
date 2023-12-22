class Request

  def initialize(uri)
    @uri = uri
  end

  def result
    @result ||= begin
      http = Net::HTTP.new(@uri.host, @uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(@uri.request_uri, {"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Safari/605.1.15"})
      response = http.request(request)
      if response.code == "200"
        JSON.parse(response.body)
      else
        raise "Unexpected result"
      end
    end
  end

end


