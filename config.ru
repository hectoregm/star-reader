ENV["RACK_ENV"] ||= "development"

require 'bundler'

Bundler.require(:default, ENV["RACK_ENV"].to_sym)

require File.expand_path(File.join(File.dirname(__FILE__), 'app'))
run StarReader
