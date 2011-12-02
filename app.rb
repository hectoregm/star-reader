require "sinatra/base"
require "sinatra/reloader"
require_relative "lib/star_helpers"
require_relative 'models/user'
require_relative 'models/star'
require "yaml"
require "time"

class StarReader < Sinatra::Base
  helpers Sinatra::StarHelpers

  configure do
    AppConfig = YAML.load_file('config.yml')
    set :haml, { :format => :html5 }
    set :glogin, { email: AppConfig["greader"]["email"],
      password: AppConfig["greader"]["password"] }

    Twitter.configure do |config|
      twitter_conf = AppConfig["twitter"]
      config.consumer_key = twitter_conf["consumer_key"]
      config.consumer_secret = twitter_conf["consumer_secret"]
      config.oauth_token = twitter_conf["oauth_token"]
      config.oauth_token_secret = twitter_conf["oauth_token_secret"]
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

    # ruby-debug config
    Debugger.settings[:reload_source_on_change] = true
    Debugger.start_remote
  end

  configure :test do
    Mongoid.configure do |c|
      db_name = AppConfig["mongoid"]["test"]["database"]
      c.master = Mongo::Connection.new.db(db_name)
    end
    User.create!(username: "hector") unless User.exists?(conditions: { username: "hector" })
  end

  before %r{^(/stars|/archive)$} do
    @user = User.find("hector")
    @rate_limit = rate_limit
    @page_title = "#{@user.username}'s Stars"
  end

  before '/stars' do
    first_login(@user) if @user.first_login?
    refresh_stars unless @user.first_login?
  end

  get '/' do
    redirect to('/stars')
  end

  get '/stars' do
    page = params[:page] || 1
    @stars = Star.unarchived.page(page)
    haml :index
  end

  get '/archive' do
    @archive = true
    @stars = Star.archived
    haml :index
  end

  post '/stars/:id/archive' do
    content_type :json
    begin
      fav = Star.find(params[:id])
      fav.archived = true
      if fav.save!
        status 200
        fav.to_json
      end
    rescue
      json_status 404, "Not Found"
    end
  end

  delete '/stars/:id/archive' do
    content_type :json
    begin
      fav = Star.find(params[:id])
      fav.archived = false
      if fav.save!
        status 200
        fav.to_json
      end
    rescue
      json_status 404, "Not Found"
    end
  end

  get '/stylesheets/star.css' do
    scss :"../styles/star", :style => :expanded
  end

end
