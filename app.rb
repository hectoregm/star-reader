require "sinatra/base"
require "sinatra/reloader"
require_relative 'models/user'
require_relative 'models/favorite'
require "twitter"
require "yaml"
require "time"

class Star < Sinatra::Base
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
  end

  configure :test do
    Mongoid.configure do |c|
      db_name = AppConfig["mongoid"]["test"]["database"]
      c.master = Mongo::Connection.new.db(db_name)
    end
  end

  helpers do
    def pretty_time(time)
      delta = (Time.now - time).to_i
      case delta
      when 0..60
        'just now'
      when 60..119
        'a minute ago'
      when 120..3599
        (delta/60).to_s + ' minutes ago'
      when 3600..7199
        'an hour ago'
      when 7200..86399
        (delta/3600).to_s + ' hours ago'
      when 86400..172799
        'a day ago'
      when 172800..604799
        (delta/86400).to_s + ' days ago'
      when 604800..1209599
        'a week ago'
      when 1209600..2678399
        (delta/604800).to_s + ' weeks ago'
      when 2678400..5270399
        ' a month ago'
      else
        (delta/2678400).to_s + ' months ago'
      end
    end

    def linkify_text(tweet)
      text = tweet[:text]
      entities = tweet[:entities][:hashtags] + tweet[:entities][:urls] + tweet[:entities][:user_mentions]
      entities.sort! {|x,y| y[:indices][0] <=> x[:indices][1] }
      entities.each do |entity|
        length = entity[:indices][1] - entity[:indices][0]
        text[entity[:indices][0], length] = "<a href=\"#{entity[:url]}\">#{entity[:display_url]}</a>" if entity[:url]
        text[entity[:indices][0], length] = "<a href=\"http://twitter.com/#{entity[:screen_name]}\">@#{entity[:screen_name]}</a>" if entity[:screen_name]
        text[entity[:indices][0], length] = "<a href=\"http://twitter.com/search?q=%23#{entity[:text]}\">##{entity[:text]}</a>" if entity[:text]
      end

      text
    end
  end

  before '/' do
    @tweets = Twitter.favorites(include_entities: true)
    @rate_limit = Twitter.rate_limit_status.remaining_hits.to_s + " Twitter API request(s) remaining this hour"
  end

  get '/' do
    haml :index
  end

  get '/stylesheets/*' do
    scss '../styles/'.concat(params[:splat].join.chomp('.css')).to_sym, :style => :expanded
  end

end
