#!/usr/bin/env rake

# Copyright(C) 2018 duangsuse

# License: AGPL-3.0
# Author: duangsuse

# Rake build script for rebased

task default: :build
task build: :shards
task shards: %w[shard.yml shard.lock]
task 'shards.lock': %w[shard.yml]

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
  rm_rf 'rebased rebased-unit'
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
