class RedditController < WEBrick::HTTPServlet::AbstractServlet

  def do_GET(request, response)
    response.keep_alive = false
    if subreddit = request.query["subreddit"]
      feed(subreddit, response)
    else
      subreddit = request.path.delete("/")
      feed(subreddit, response)
    end
  end

  def feed(subreddit, response)
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

  def uri(subreddit)
    @uri ||= begin
      URI::HTTPS.build(
        host: "old.reddit.com",
        path: "/r/#{subreddit}/top.json",
        query: "limit=20",
      )
    end
  end

end