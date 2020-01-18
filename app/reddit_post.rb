class RedditPost

  GFYCAT_URL = /https?:\/\/(?:(?:www|giant|thumbs)\.)?gfycat\.com\/(?:ru\/|ifr\/|gifs\/detail\/)?(?<video_id>[^-\/?#\.]+)/

  def initialize(data)
    @data = data
  end

  def url
    "https://www.reddit.com#{@data.dig("data", "permalink")}"
  end

  def published
    date = @data.dig("data", "created_utc") || Time.now.to_i
    date = Time.at(date)
    date.utc.strftime '%Y-%m-%dT%H:%M:%S%z'
  end

  def id
    @data.dig("data", "id")
  end

  def title
    @data.dig("data", "title")
  end

  def author
    @data.dig("data", "author")
  end

  def media_type
    hint = @data.dig("data", "post_hint")
    if hint == "link"
      if @data.dig("data", "domain") == "imgur.com" || @data.dig("data", "domain") == "i.imgur.com"
        hint = "imgur"
      end
    elsif @data.dig("data", "url") && GFYCAT_URL =~ @data.dig("data", "url")
      @gfycat_id = $1
      hint = "gfycat"
    elsif @data.dig("data", "media", "oembed")
      hint = "oembed"
    end
    hint
  end

  def media_url
    @data.dig("data", "url")
  end

  def reddit_video
    @data.dig("data", "crosspost_parent_list", 0, "secure_media", "reddit_video") || @data.dig("data", "secure_media", "reddit_video")
  end

  def poster
    if reddit_video
      @data.dig("data", "preview", "images", 0, "source", "url")
    end
  end

  def oembed
    html = @data.dig("data", "media", "oembed", "html")
    if html
      CGI.unescapeHTML(html)
    else
      nil
    end
  end

  def imgur_id
    if media_url
      parsed_url = URI.parse(media_url)
      if parsed_url.host == "i.imgur.com" || parsed_url.host == "imgur.com"
        path = parsed_url.path.split("/")
        if path.length == 2
          path.last.gsub(".gifv", "").gsub(".gif", "").gsub(".jpg", "").gsub(".jpeg", "")
        end
      end
    end
  end

  def gfycat_poster
    gfycat_data.dig("gfyItem", "posterUrl")
  rescue
    nil
  end

  def gfycat_url
    gfycat_data.dig("gfyItem", "mp4Url")
  rescue
    nil
  end

  def gfycat_data
    @gfycat_data ||= begin
      Request.new(URI("https://api.gfycat.com/v1/gfycats/#{@gfycat_id}")).result
    end
  rescue
    nil
  end

  def imgur_url
    "https://imgur.com/#{imgur_id}"
  end

  def imgur_image_url
    "#{imgur_url}.gif"
  end

end