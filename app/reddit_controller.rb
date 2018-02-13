class RedditController < WEBrick::HTTPServlet::AbstractServlet

  def do_GET(request, response)
    response.keep_alive = false
    case request.path
    when "/reddit"
      feed(request, response)
    end
  end

  def feed(request, response)
    if subreddit = request.query["subreddit"]
      url = uri(subreddit)
      puts url.inspect
      request = Request.new(url)
      result = request.result
      feed = RedditFeed.new(result, subreddit)
      body = feed.render

      response.status = 200
      response.content_type = "text/xml"
      response.body = body
    end
  end

  def uri(subreddit)
    @uri ||= begin
      URI::HTTPS.build(
        host: "www.reddit.com",
        path: "/r/#{subreddit}/top.json",
        query: "limit=20",
      )
    end
  end

end