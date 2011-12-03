require "sinatra/base"
require "sinatra/reloader"
require 'sinatra/jstpages'
require_relative "lib/star_helpers"
require_relative 'models/user'
require_relative 'models/star'
require "yaml"
require "time"

class StarReader < Sinatra::Base
  register Sinatra::JstPages
  helpers Sinatra::StarHelpers

  serve_jst '/javascripts/jst.js'

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

  before '/' do
    @user = User.find("hector")
    @rate_limit = rate_limit
    @page_title = "#{@user.username}'s Stars"
  end

  # before '/' do
  #   first_login(@user) if @user.first_login?
  #   refresh_stars unless @user.first_login?
  # end

  get '/' do
    @stars = Star.unarchived.page(1)
    haml :index
  end

  get '/stars' do
    content_type :json

    page = 1
    page = params[:page].to_i if params[:page]

    status 200

    if params[:sort] == 'archived'
      Star.archived.page(page).to_json
    else
      Star.unarchived.page(page).to_json
    end
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
