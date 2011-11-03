ENV['RACK_ENV'] = "test"

require 'bundler'
Bundler.require(:default, :test)
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))
require 'rack/test'
require 'capybara/rspec'

set :environment, :test

def data_path(filename)
  File.expand_path(File.join(File.dirname(__FILE__), 'data', filename))
end

tweets = File.read(data_path('favorites_twitter.json'))
entries = File.read(data_path('favorites_greader.atom'))
FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:get,
                     'https://api.twitter.com/1/favorites.json?page=1&include_entities=true',
                     body: tweets)
FakeWeb.register_uri(:get,
                     'https://api.twitter.com/1/favorites.json?page=2&include_entities=true',
                     body: "[]")
FakeWeb.register_uri(:post,
                     'https://www.google.com/accounts/ClientLogin',
                     body: "")
FakeWeb.register_uri(:get,
                     %r|http://www\.google\.com/reader/atom/user/\-/state/com\.google/starred|,
                     body: entries)
FakeWeb.register_uri(:get,
                     "https://api.twitter.com/1/account/rate_limit_status.json",
                     body: "{\"remaining_hits\":347}")

RSpec.configure do |c|
  c.include Rack::Test::Methods
  c.include Capybara::RSpecMatchers

  c.after(:each) do
    Mongoid.master.collections
      .select { |cl| cl.name !~ /system/ }.each(&:drop)
    User.create!(username: "hector", first_login: false)
  end
end
