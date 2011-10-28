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
    set :haml, { :format => :html5 }
    AppConfig = YAML.load_file('config.yml')

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
  end

  configure :test do
    Mongoid.configure do |c|
      db_name = AppConfig["mongoid"]["test"]["database"]
      c.master = Mongo::Connection.new.db(db_name)
    end
  end

  before '/' do
    load_all_tweets
    @rate_limit = rate_limit
  end

  get '/' do
    @tweets = Favorite.all.order_by([[:ocreated_at, :desc]])
    haml :index
  end

  get '/stylesheets/*' do
    scss '../styles/'.concat(params[:splat].join.chomp('.css')).to_sym, :style => :expanded
  end

end
