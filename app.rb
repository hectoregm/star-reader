require "sinatra/base"
require "sinatra/reloader"
require "twitter"
require "haml"
require "sass"

class Star < Sinatra::Base

  configure do
    set :haml, { :format => :html5 }
    @@config = YAML.load_file('config.yml')

    Twitter.configure do |config|
      config.consumer_key = @@config["twitter"]["consumer_key"]
      config.consumer_secret = @@config["twitter"]["consumer_secret"]
      config.oauth_token = @@config["twitter"]["oauth_token"]
      config.oauth_token_secret = @@config["twitter"]["oauth_token_secret"]
    end
  end

  configure :development do
    register Sinatra::Reloader
    also_reload "*.rb"
  end

  get '/' do
    haml :index
  end

  get '/stylesheets/*' do
    scss '../styles/'.concat(params[:splat].join.chomp('.css')).to_sym, :style => :expanded
  end

end
