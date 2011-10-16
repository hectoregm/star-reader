require File.join(File.dirname(__FILE__), '..', 'app.rb')
require 'bundler'
require 'sinatra'
require 'rspec'
require 'rack/test'
require 'capybara/rspec'

set :environment, :test

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include Capybara::RSpecMatchers
end
