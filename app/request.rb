class Request

  def initialize(uri)
    @uri = uri
  end

  def result
    @result ||= begin
      http = Net::HTTP.new(@uri.host, @uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(@uri.request_uri, {"User-Agent" => "Feed Maker"})
      response = http.request(request)
      if response.code == "200"
        JSON.parse(response.body)
      else
        raise "Unexpected result"
      end
    end
  end

end


