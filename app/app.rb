#!/usr/bin/env ruby

$stdout.sync = true

require "erb"
require "uri"
require "json"
require "webrick"
require "net/http"

require_relative "request"
require_relative "reddit_controller"
require_relative "reddit_feed"
require_relative "reddit_post"