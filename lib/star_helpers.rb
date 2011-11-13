require 'sinatra/base'

module Sinatra

  module StarHelpers

    def first_login(user)
      load_all_tweets
      load_all_entries(greader_login(settings.glogin))
      user.first_login = false
      user.save!
    end

    def refresh_favorites
      refresh_tweets
      refresh_entries(greader_login(settings.glogin))
    end

    def link_author(fav)
      build_link(fav.author_url, fav.author)
    end

    def pretty_time(time)
      delta = (Time.now - time).to_i
      case delta
      when 0..59
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
      when 1209600..2419199
        (delta/604800).to_s + ' weeks ago'
      when 2419200..5270399
        'a month ago'
      when 5270400..31535999
        (delta/2635200).to_s + ' months ago'
      when 31536000..63071999
        'a year ago'
      else
        (delta/31536000).to_s + ' years ago'
      end
    end

    def rate_limit
      Twitter.rate_limit_status.remaining_hits.to_s +
        " Twitter API request(s) remaining this hour"
    end

    private

    def load_all_tweets
      page = 1
      loop do
        tweets = Twitter.favorites(page: page,
                                   include_entities: true)
        break if tweets.empty?
        tweets.each do |t|
          next if Favorite.exists?(conditions: { source_id: t.id })
          author = t.user.screen_name
          Favorite.create!(source: 'twitter',
                           source_id: t.id,
                           image_url: t.user.profile_image_url,
                           author: author,
                           author_url: "http://twitter.com/#{author}",
                           content: linkify_text(t.text,
                                                 t.entities),
                           ocreated_at: Time.parse(t.created_at))
        end

        page += 1
      end
    end

    def load_all_entries(user)
      entries = greader_starred_items(user)[0]
      entries.each do |e|
        id = e.id.content
        next if Favorite.exists?(conditions: { source_id: id })
        content =  e.content ? e.content.content : e.summary.content
        title = build_link(e.link.href, e.title.content)
        Favorite.create!(source: 'greader',
                         source_id: id,
                         image_url: "/images/greader.png",
                         author: e.source.title.content,
                         author_url: e.source.link.href,
                         title: title,
                         content: content,
                         ocreated_at: e.published.content)
      end
    end

    def refresh_tweets
      page = 1
      loop do
        tweets = Twitter.favorites(page: page,
                                   include_entities: true)
        break if tweets.empty?

        tweets.each do |t|
          return if Favorite.exists?(conditions: { source_id: t.id })
          author = t.user.screen_name
          Favorite.create!(source: 'twitter',
                           source_id: t.id,
                           image_url: t.user.profile_image_url,
                           author: author,
                           author_url: "http://twitter.com/#{author}",
                           content: linkify_text(t.text,
                                                 t.entities),
                           ocreated_at: Time.parse(t.created_at))
        end

        page += 1
      end
    end

    def refresh_entries(user)
      continuation = nil
      count = 0
      loop do
        entries, continuation = greader_starred_items(user,
                                                      { n: 5, c: continuation })
        entries.each do |e|
          id = e.id.content
          return if Favorite.exists?(conditions: { source_id: id})
          content = e.content ? e.content.content : e.summary.content
          title  = build_link(e.link.href, e.title.content)
          Favorite.create!(source: 'greader',
                           source_id: id,
                           image_url: "/images/greader.png",
                           author: e.source.title.content,
                           author_url: e.source.link.href,
                           title: title,
                           content: content,
                           ocreated_at: e.published.content)
        end

        count += 5
        break if entries.empty? || count == 20
      end
    end

    def build_link(href, text)
      "<a href=\"#{href}\">#{text}</a>"
    end

    def greader_login(hash)
      GoogleReaderApi::User.new(email: hash[:email],
                                password: hash[:password])
    end

    def greader_starred_items(user, options={})
      defaults = { n: 40, c: '' }
      options = defaults.merge(options)

      data = user.api.get_link('atom/user/-/state/com.google/starred',
                               options)

      if data.empty?
        continuation = ''
        entries = []
      else
        continuation = get_continuation(data)
        # FIXME: Hack to piggyback the creation of the entries to RssUtils
        obj = Object.new
        obj.extend(GoogleReaderApi::RssUtils)
        entries = obj.send(:create_entries, data).collect! { |e| e.entry }
      end

      [entries, continuation]
    end

    def get_continuation(data)
      result = ""
      creg = /<gr:continuation>(.*)<\/gr:continuation>/
      result = data.match(creg).captures[0] if data.match(creg)

      result
    end

    def linkify_text(tweet_text, tweet_entities)
      entities = tweet_entities.collect { |e,v| v }.flatten
      entities.sort! {|x,y| y[:indices][0] <=> x[:indices][1] }
      entities.each do |entity|
        length = entity[:indices][1] - entity[:indices][0]

        result = case
                 when url = entity.url
                   display_url = entity.display_url || url
                   build_link(url, display_url)
                 when user = entity.screen_name
                   build_link("http://twitter.com/#{user}",
                              '@' + user)
                 when ht = entity.text
                   build_link("http://twitter.com/search?q=%23#{ht}",
                              "##{ht}")
                 end

        tweet_text[entity[:indices][0], length] = result
      end

      tweet_text
    end

  end

  helpers StarHelpers

end
