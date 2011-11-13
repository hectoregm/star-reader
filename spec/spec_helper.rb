ENV['RACK_ENV'] = "test"

require 'bundler'
Bundler.require(:default, :test)
require File.expand_path(File.join(File.dirname(__FILE__), '../app'))
require 'rack/test'
require 'capybara/rspec'
require 'singleton'

set :environment, :test

class SetupFakeweb
  include Singleton

  def initialize
    FakeWeb.allow_net_connect = false
    @tweets = File.read(data_path('tweets.json'))
    @entries = File.read(data_path('entries.atom'))
    @entries2 = File.read(data_path('entries_refresh_1.atom'))
    @entries3 = File.read(data_path('entries_refresh_2.atom'))
    @new_tweets = File.read(data_path('tweets_refresh.json'))
    setup_mock_requests
  end

  def reset
    FakeWeb.clean_registry
    setup_mock_requests
  end

  def setup_mock_requests
    FakeWeb.register_uri(:get,
                         'https://api.twitter.com/1/favorites.json?page=1&include_entities=true',
                         [{ body: @tweets },
                          { body: @new_tweets }])
    FakeWeb.register_uri(:get,
                         'https://api.twitter.com/1/favorites.json?page=2&include_entities=true',
                         body: "[]")
    FakeWeb.register_uri(:post,
                         'https://www.google.com/accounts/ClientLogin',
                         body: "")

    FakeWeb.register_uri(:get,
                         %r|http://www\.google\.com/reader/atom/user/\-/state/com\.google/starred|,
                         [{ body: @entries },
                          { body: @entries2 },
                          { body: @entries3 }])
    FakeWeb.register_uri(:get,
                         "https://api.twitter.com/1/account/rate_limit_status.json",
                         body: "{\"remaining_hits\":347}")
  end

  private
  def data_path(filename)
    File.expand_path(File.join(File.dirname(__FILE__), 'data', filename))
  end
end

module ViewHelpers
  def render(template_path)
    path = File.expand_path(File.join(File.dirname(__FILE__), '..', template_path))
    template = File.read(path)
    engine = Haml::Engine.new(template)
    @response = engine.render(self, assigns_for_template)
  end

  # Convenience method to access the @response instance variable set in
  # the render call
  def response
    @response
  end

  # Convenience method to access the params
  def params
    @params ||= { }
  end

  # Sets the local variables that will be accessible in the HAML
  # template
  def assigns
    @assigns ||= { }
  end

  # Prepends the assigns keywords with an "@" so that they will be
  # instance variables when the template is rendered.
  def assigns_for_template
    assigns.inject({}) do |memo, kv|
      memo["@#{kv[0].to_s}".to_sym] = kv[1]
      memo
    end
  end
end

Capybara.app = Star

RSpec.configure do |c|
  c.include Rack::Test::Methods
  c.include Capybara::RSpecMatchers
  c.include ViewHelpers, :type => :views
  c.include Sinatra::StarHelpers, :type => :views

  c.before(:each) do
    SetupFakeweb.instance.reset
  end

  c.after(:each) do
    Mongoid.master.collections
      .select { |cl| cl.name !~ /system/ }.each(&:drop)
    User.create!(username: "hector")
  end
end
