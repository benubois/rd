class RedditFeed

  def initialize(data, subreddit)
    @data = data
    @subreddit = subreddit
    @template = File.read(File.expand_path('../reddit_template.erb', __FILE__))
  end

  def title
    @subreddit
  end

  def posts
    nodes = @data.dig("data", "children") || []
    nodes.map do |post|
      RedditPost.new(post)
    end
  end

  def render
    ERB.new(@template).result(binding)
  end

end
