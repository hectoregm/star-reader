require 'sinatra/base'

module Sinatra
  module StarHelpers

    def first_login(user)
      load_all_tweets
      guser = greader_login(settings.glogin)
      load_all_entries(guser)
      user.first_login = false
      user.save!
    end

    def greader_login(hash)
      GoogleReaderApi::User.new(email: hash[:email],
                                password: hash[:password])
    end

    def link_author(fav)
      case fav.source
      when 'twitter'
        "<a href=\"http://twitter.com/#{fav.author}\">#{fav.author}</a>"
      when 'greader'
        "<a href=\"http://twitter.com/#{fav.author_link}\">#{fav.author}</a>"
      end
    end

    def greader_starred_items(api)
      obj = Object.new
      obj.extend(GoogleReaderApi::RssUtils)
      data = api.get_link 'atom/user/-/state/com.google/starred', n: 40
      obj.send(:create_entries, data)
    end

    def load_all_tweets
      page = 1
      loop do
        tweets = Twitter.favorites(page: page,
                                   include_entities: true)
        break if tweets.empty?
        tweets.each do |tweet|
          next if Favorite.exists?(conditions: { source_id: tweet.id })
          Favorite.create!(source: 'twitter',
                           source_id: tweet.id,
                           image_url: tweet.user.profile_image_url,
                           author: tweet.user.screen_name,
                           content: linkify_text(tweet.text,
                                                 tweet.entities),
                           ocreated_at: Time.parse(tweet.created_at))
        end
        page += 1
      end
    end

    def load_all_entries(reader)
      entries = greader_starred_items(reader.api)
      entries.map! { |i| i.entry }
      entries.each do |entry|
        next if Favorite.exists?(conditions: { source_id: entry.id.content })
        content = entry.content ? entry.content.content : entry.summary.content
        title  = "<a href=\"#{entry.link.href}\">#{entry.title.content}</a>"
        Favorite.create!(source: 'greader',
                         source_id: entry.id.content,
                         image_url: "/images/greader.png",
                         author: entry.source.title.content,
                         author_link: entry.source.link.href,
                         title: title,
                         content: content,
                         ocreated_at: entry.published.content)
      end
    end

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

    def linkify_text(tweet_text, tweet_entities)
      entities = tweet_entities.collect { |e,v| v }.flatten
      entities.sort! {|x,y| y[:indices][0] <=> x[:indices][1] }
      entities.each do |entity|
        length = entity[:indices][1] - entity[:indices][0]

        result = case
        when url = entity.url
          display_url = entity.display_url || url
          "<a href=\"#{url}\">#{display_url}</a>"
        when user = entity.screen_name
          "<a href=\"http://twitter.com/#{user}\">@#{user}</a>"
        when hashtag = entity.text
          "<a href=\"http://twitter.com/search?q=%23#{hashtag}\">##{hashtag}</a>"
        end

        tweet_text[entity[:indices][0], length] = result
      end

      tweet_text
    end

    def rate_limit
      Twitter.rate_limit_status.remaining_hits.to_s +
        " Twitter API request(s) remaining this hour"
    end

  end

  helpers StarHelpers

end
