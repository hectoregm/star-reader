ENV['RACK_ENV'] = 'test'

require 'bundler'
Bundler.require(:default, :test)
require File.expand_path(File.join(File.dirname(__FILE__), '../../app'))
require 'capybara/cucumber'


Capybara.app = StarReader
Capybara.javascript_driver = :webkit
Capybara.default_wait_time = 10

class StarWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  StarWorld.new
end
