#!/usr/bin/env rake

# Copyright(C) 2018 duangsuse

# License: AGPL-3.0
# Author: duangsuse

# Rake build script for rebased

task default: :build
task build: :shards
task run: :build
task shards: %w[shard.yml shard.lock]
task 'shards.lock': %w[shard.yml]
task spec: :check
task test: :check

# Crystal compiler
def crystalc(file)
  flags=ENV['CRYSTALFLAGS'] || ''
  if ENV['REL']
    puts "Compiling #{file} in release mode"
    flags += '--release'
  end
  sh "crystal build #{file} -p -s #{flags}"
end

# Build default executable
task :build do
  crystalc 'rebased.cr'
end

# Get shards
# Ignore if shards lib exists
task :shards do
  sh 'shards' unless File.exist?('lib')
end

# Build for the first time
# Ignore if lock file exists
task 'shard.lock' do
  sh 'shards' unless File.exist?('shard.lock')
end

# Clean files
task :clean do
  sh 'rm -f rebased rebased-unit'
end

# Clean deps
task :cleandeps do
  rm_rf %w[lib shard.lock]
end

# Check server
task :check do
  crystalc 'rebased-unit.cr'
  sh './rebased-unit'
end

# Build shards
task :'shards-build' do
  sh 'shards build'
end

public
# Sudo sh command
def sudosh(command, *commands, &block)
  list = [command] + commands
  list.map! do |c|
    "sudo #{c}"
  end

  send(:sh, *list) &block
end

# Systemd config path
def systemd_path
  '/lib/systemd/system/'
end

# Install program
task :install do
  sudosh "cp rebased.service #{systemd_path}"
  sudosh 'install -Dm755 rebased /root'
end

# Remove program
task :uninstall do
  sudosh "rm -f #{systemd_path}/rebased.service"
  sudosh 'rm -f /root/rebased'
end

# Start program
task :start do
  sudosh 'systemctl start rebased'
  sudosh 'systemctl status rebased'
end

# Run server
task :run do
  sh './rebased'
end
