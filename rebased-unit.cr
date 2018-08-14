#!/usr/bin/env crystal

# JSON HTTP RESTFul Connection 
require "cossack"
require "json"

# Crystal spec DSL library
#require "spec"

# Colored test output
require "colorize"

# Test script for Rebased server

# Copyright(C) 2018 duangsuse

# Bad `Process#spawn` workaround
class Process
  # An implementation of `Process.singleton_class#spawn`
  #
  # Child class using parent process's stdio
  #
  # *path* program path
  #
  # *Return* Child process PID
  def self.spawn!(path)
    puts "Running #{path}"
    p = Process.new(path, nil, nil, false, false, Redirect::Inherit, Redirect::Inherit, Redirect::Inherit)
    return p.pid
  end
end

# License: AGPL-3.0
# Author: duangsuse
class RebasedTests
  # IV Type decl
  @tested : UInt32 = 0
  @failed : UInt32 = 0
  @time : Time = Time.new
  @program : String
  @pid : Int32
  @conn : Cossack::Client

  # Class intializer, creates program/pid/conn instance variables
  def initialize
    # Binary to launch
    @program = "./rebased"

    # Use command-line program if given 
    @program = ARGV[0] if ARGV.size > 0

    @pid = -1 # Saved pid
    @conn = Cossack::Client.new # Test connection
  end

  # Open server process
  def program_open(p = nil)
    p = p || @program
    puts "Opening executable file: #{p.colorize(:green)}".colorize.mode(:bright)
    if File.exists?(p)
      @pid = Process.spawn!(p)
    else
      abort "Bad file path. Please check again".colorize(:red)
    end
  end

  # Kill server process
  def program_close(pid = nil)
    pid = pid || @pid
    puts "Closing process #{pid.colorize(:green)}".colorize.mode(:bright)
    if Process.exists?(pid)
      Process.kill(:TERM, pid) unless pid == -1
    else
      abort "Process already killed".colorize(:red)
    end
  end

  # Default listening address
  def default_listen
    ENV.has_key?("TEST_LISTEN") ? ENV["TEST_LISTEN"] : "http://127.0.0.1:8080"
  end

  # Initializes faraday connection
  def initialize_conn
    puts "⛓  Opening connection to #{default_listen.colorize(:blue)}"
    @conn = Cossack::Client.new(default_listen) do |client|
      client.request_options.connect_timeout = 2.seconds
      client.request_options.read_timeout = 3.seconds
    end  
  end

  # Ensure body is text
  def assert_body(resp, expected)
    body = resp.body
    begin
      raise "Assertion failed: #{body.colorize(:red)} != #{expected.colorize(:blue)}" unless body == expected
    rescue Encoding::CompatibilityError
      raise "Assertion failed: #{body.colorize(:red)} != #{expected.colorize(:blue)}" unless body.bytes.size == expected.bytes.size
    end
  end

  # Do tests for rebased
  def do_tests
      puts "🖍  Running tests for Rebased API".colorize(:magenta).mode(:bright)

      # Begin tests logic
  end

  # Report test result
  def report
    time_ms = (Time.new - @time).milliseconds
    passed = @tested - @failed
    puts "📸  Finished in #{time_ms.colorize(:cyan).mode(:bright)} milliseconds"
    puts "#{@tested.colorize(:yellow)} tested, #{passed.colorize(:green)} passes, #{@failed.colorize(:red)} failed"
  end

  # Main CLI program
  def run
    puts "🌡  Testing #{@program}.".colorize(:yellow)
    program_open # Open server
    initialize_conn # Open connection
    begin
      do_tests # Run tests
    ensure
      program_close # Ensure server program is closed
    end
    report # Report test result
  end
end

# Start if not 'require' d
tests = RebasedTests.new

# Run tests
tests.run if __FILE__.includes?("rebased-unit")
