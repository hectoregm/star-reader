ENV['RACK_ENV'] = 'test'

require 'bundler'
Bundler.require(:default, :test)
require File.expand_path(File.join(File.dirname(__FILE__), '../../app'))
require 'capybara/cucumber'


Capybara.app = Star
Capybara.javascript_driver = :webkit

class StarWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  StarWorld.new
end
