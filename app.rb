require "sinatra/base"
require "sinatra/reloader"
require_relative "lib/star_helpers"
require_relative 'models/user'
require_relative 'models/favorite'
require "twitter"
require "yaml"
require "time"

class Star < Sinatra::Base
  helpers Sinatra::StarHelpers

  configure do
    AppConfig = YAML.load_file('config.yml')
    set :haml, { :format => :html5 }
    set :glogin, { email: AppConfig["greader"]["email"],
                   password: AppConfig["greader"]["password"] }

    Twitter.configure do |config|
      config.consumer_key = AppConfig["twitter"]["consumer_key"]
      config.consumer_secret = AppConfig["twitter"]["consumer_secret"]
      config.oauth_token = AppConfig["twitter"]["oauth_token"]
      config.oauth_token_secret = AppConfig["twitter"]["oauth_token_secret"]
    end

  end

  configure :development do
    register Sinatra::Reloader
    also_reload "*.rb"

    Mongoid.configure do |c|
      db_name = AppConfig["mongoid"]["development"]["database"]
      c.master = Mongo::Connection.new.db(db_name)
    end

    set :logging, true
    Mongoid.logger = Logger.new($stdout)
    User.create!(username: "hector") unless User.exists?(conditions: { username: "hector" })
  end

  configure :test do
    Mongoid.configure do |c|
      db_name = AppConfig["mongoid"]["test"]["database"]
      c.master = Mongo::Connection.new.db(db_name)
    end
  end

  before '/' do
    user = User.find("hector")
    first_login(user) if user.first_login?
    refresh_favorites unless user.first_login?
    @rate_limit = rate_limit
  end

  get '/' do
    @favorites = Favorite.all.order_by([[:ocreated_at, :desc]])
    haml :index
  end

  get '/stylesheets/star.css' do
    scss :"../styles/star", :style => :expanded
  end

end
