require_relative "app"

server = WEBrick::HTTPServer.new(
  Port: ENV["PORT"] || 1234,
  DocumentRoot: File.expand_path('../../public', __FILE__)
)

server.mount "/", RedditController

["INT", "TERM", "HUP"].each do |signal|
  trap(signal) { server.shutdown }
end

server.start
