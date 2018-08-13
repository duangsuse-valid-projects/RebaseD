#!/usr/bin/env crystal

# Required for high-performance routing
require "router"

# Required for JSON datastorage and RESTFul API
require "json"

# Rebase API server, compatible with API __v0.7.2__

# Copyright(C) 2018 duangsuse

# License: AGPL-3.0
# Author: duangsuse

# RebaseD server version
VERSION = "0.1.0"

# Compatible Rebase API Version
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
    # Adds CORS header - allow all
    context.response.headers["Access-Control-Allow-Origin"] = "*"
    call_next(context)
  end
end

# Another simple Crystal `HTTP::Server` CORS header middleware
#
# It sets `Content-Type` header as `Content-Type: application/json; charset=utf-8` in response context
#
# To use as **JSON API** middleware
#
# ```
# HTTP::Server.new([route_handler, JSONHandler.new])
# ```
class JSONHandler
  include HTTP::Handler

  # Content-Type field
  CONTENT_TYPE_HEADER = "Content-Type"

  # JSON REST content type value
  JSON_TYPE = "application/json; charset=utf-8"

  # JSON header handler
  # Overrides `HTTP::Handler#call`, and call next handler
  def call(context : HTTP::Server::Context) : Void
    # Make JSON header - charset=utf-8
    context.response.headers[CONTENT_TYPE_HEADER] = JSON_TYPE
    call_next(context)
  end
end

# Rebase data models storage
#
# Execute queries, make data persistence, generate JSONs
#
# Including these models
#
# + User model
# + Category model
# + Feed model
class RebaseModel
  struct User
  end

  struct Category
  end

  struct Feed
  end

  def initialize
  end
end

# Alias for `HTTP::Server::Context`
alias Context = HTTP::Server::Context

# A simple [Rebase API](https://github.com/drakeet/rebase-api) server
#
# RESTFul HTTP Web server, using a JSON data storage `RebaseModel`
#
# See API document [here](https://github.com/duangsuse/RebaseD/blob/master/rebase-api.md)
# 
# Using __router.cr__ and __Radix tree__ to route requests
class RebaseServer
  include Router # Router mixin

  # Host environment variable name
  HOST_ENV = "REBASED_HOST"

  # Port environment variable name
  PORT_ENV = "REBASED_PORT"

  # Default storage file
  DEFAULT_DATABASE = "rebase.json"

  # The datas torage property
  property datastorage : RebaseModel

  # Initialize with storage
  def initialize(@datastorage : RebaseModel = RebaseModel.new)
  end

  # Print a line of text to context response, overriding `HTTP::Server::Response#content_type`
  #
  # *ctx* references to target context
  #
  # *text* is the text to print
  def text(ctx : Context, text : String) : String
    ctx.response.content_type = "text/plain"
    ctx.response.print(text)
    return text
  end

  # Print text to context response
  #
  # *ctx* references to target context
  #
  # *content* is the text to print
  def rputs(ctx : Context, content : String) : String
    ctx.response.print(content)
    return content
  end

  # Set response code of an `HTTP::Server::Context` object
  #
  # + *ctx* context Object
  # + *status* status code, default __404__
  def response_code(ctx : Context, status = 404)
    ctx.response.status_code = status
  end

  # Content-Type changer for Context object
  #
  # + *ctx* `Context` object to use
  # + *label* `Content-Type` header value
  #
  # *Return* new `Content-Type` header value
  def content_type(ctx : Context, label : String = "text/plain") : String
    ctx.response.content_type = label
    return label
  end

  # Get POST query string from context
  #
  # + *ctx* `Context` object to use
  # + *name* param name 
  #
  # *Return* param value or `nil`
  def query(ctx : Context, name : String) : (String | Nil)
    request.query_params.has_key?(name) ? request.query_params[name].encode("utf-8") : nil
  end

  # Setup radix routers in application
  #
  # See API Documents [here](https://github.com/duangsuse/RebaseD#api--%E7%BD%91%E7%BB%9C%E6%8E%A5%E5%8F%A3)
  #
  # + __GET__ /
  # + __GET__ /version
  # + __GET__ /api-version
  def routerize! : Void
    # API Index page
    get "/" do |ctx|
      text(ctx, "Hello World!")
      next ctx
    end

    # Program version
    get "/version" do |ctx|
      text(ctx, VERSION)
      next ctx
    end

    # API version
    get "/api-version" do |ctx|
      text(ctx, API_VERSION)
      next ctx
    end
  end

  # Run application
  #
  # Make use of environment `PORT_ENV`
  #
  # *host* listening host, default __127.0.0.1__
  #
  # Will be **overrided** by environment variable `REBASED_HOST`
  #
  # *port* listening port, default __8080__
  #
  # Will be **overrided** by environment variable `REBASED_PORT`
  def run(host = "127.0.0.1", port : Int32 = 8080) : Nil
    # Make server configured
    port = ENV[PORT_ENV].to_i if ENV.has_key?(PORT_ENV) # Port
    host = ENV[HOST_ENV] if ENV.has_key?(HOST_ENV) # Host

    # Initialize Crystal server
    server = HTTP::Server.new([route_handler, CORSHandler.new, JSONHandler.new])

    # Do Unix bind() syscall, rescue errors
    begin
      server.bind_tcp(host, port)
    rescue e : Errno
      abort "Failed to bind() to #{host}:#{port}: #{e}"
    end

    puts "Rebase service bind() finished"
    puts "Listening on http://#{host}:#{port}"
    server.listen # Listen
  end
end

# Run application
puts "Initializing Rebase API Server v#{VERSION}"
server = RebaseServer.new

# Routerize
puts "Setting up router routes"
server.routerize!

# Start HTTP server
if __FILE__.includes?("rebased")
  puts "Binding HTTP service v#{API_VERSION}"
  server.run
end
