#!/usr/bin/env crystal

require "router"
require "json"

# Rebase API server

# Copyright(C) 2018 duangsuse

# License: AGPL-3.0
# Author: duangsuse

# Server version
VERSION = "0.1.0"

# Compatible API Version
API_VERSION = "0.7.2"

# A simple Crystal `HTTP::Server` CORS header middleware
#
# It adds `Access-Control-Allow-Origin` header as `*` in response context
#
# To use as **CORS** middleware
#
# ```
# HTTP::Server.new([route_handler, CORSHandler.new])
# ```
class CORSHandler
  include HTTP::Handler

  # CORS header handler
  # Overrides `HTTP::Handler#call`, and call next handler
  def call(context : HTTP::Server::Context) : Void
    context.response.headers["Access-Control-Allow-Origin"] = "*"
    call_next(context)
  end
end

# A simple [Rebase API](https://gist.github.com/duangsuse/ece970be30694c1de91307cc396661ec) server
# 
# Using __router.cr__ and __Radix tree__ to route
class RebaseServer
  include Router # Router

  # Host environment variable name
  HOST_ENV = "REBASED_HOST"

  # Port environment variable name
  PORT_ENV = "REBASED_PORT"

  # The datas torage property
  property datastorage

  # Initialize with storage
  def intialize(datastorage : RebaseModel = RebaseModel.file("rebase.json"))
  end

  # Print a line of text to context response, overriding `HTTP::Server::Response#content_type`
  #
  # *ctx* references to target context
  #
  # *text* is the text to print
  def text(ctx, text) : String
    ctx.response.content_type = "text/plain"
    ctx.response.print(text)
    return text
  end

  # Setup routers in application
  #
  # + GET /
  # + POST /p1s
  # + POST /comment
  # + GET /comment/list
  # + DELETE /comment/:nth
  def routerize! : Void
    get "/" do |ctx|
      text(ctx, "Hello World!")
      next ctx
    end

    post "/p1s" do |ctx|
      @secs += 1
      text(ctx, @secs.to_s)
      next ctx
    end

    post "/comment" do |ctx|
      @msgs << if ctx.request.query_params.has_key?("content")
        text(ctx, String.new(ctx.request.query_params["content"].encode("utf-8")))
      else
        text(ctx, "GeekApk 万岁 🧀")
      end
      next ctx
    end

    get "/comment/list" do |ctx|
      text(ctx, {list: @msgs}.to_json)
      ctx.response.content_type = "application/json"
      next ctx
    end

    delete "/comment/:nth" do |ctx, params|
      begin
        text(ctx, @msgs.delete_at(params["nth"].to_i))
      rescue err : IndexError
        text(ctx, "Comment not found")
        ctx.response.status_code = 404
      end
      next ctx
    end
  end

  # Run application
  #
  # Make use of environment `PORT_ENV`
  #
  # *host* listening host, default __127.0.0.1__
  #
  # *port* listening port, default __8080__
  def run(host = "127.0.0.1", port = nil) : Nil
    # Make server configured
    if ENV.has_key?(PORT_ENV)
      port = ENV[PORT_ENV].to_i
    else
      port = 8080 unless port # Port
    end
    host = ENV[HOST_ENV] if ENV.has_key?(HOST_ENV) # Host

    # Initialize Crystal server
    server = HTTP::Server.new([route_handler, CORSHandler.new])
    server.bind_tcp(host, port) # Call Unix bind()
    puts "Rebase service bind() OK"
    puts "Listening on http://#{host}:#{port}"
    server.listen # Listen
  end
end

# Run application
puts "Initializing Rebase API Server"
server = RebaseServer.new

# Routerize
puts "Setting up router routes"
server.routerize!

# Start HTTP server
if __FILE__.includes?("rebased")
  puts "Binding HTTP service"
  server.run
  puts "Server stopped, have a nice day ;)"
end
