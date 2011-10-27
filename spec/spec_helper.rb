ENV['RACK_ENV'] = "test"

require 'bundler'
Bundler.require(:default, :test)
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))
require 'rack/test'
require 'capybara/rspec'

set :environment, :test

RSpec.configure do |c|
  c.include Rack::Test::Methods
  c.include Capybara::RSpecMatchers

  c.before(:each) do
    Mongoid.master.collections
      .select { |cl| cl.name !~ /system/ }.each(&:drop)
  end
end
