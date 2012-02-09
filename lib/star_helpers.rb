require 'sinatra/base'

module Sinatra

  module StarHelpers

    class ResponseWithFormat

      FORMATS = [:html, :json]

      def initialize(scope)
        @scope = scope
        @handlers = { }
      end

      def method_missing(m, *args, &handler)
        super unless FORMATS.include? m
        @handlers[m] = handler
      end

      def response
        if @scope.request.xhr? && @handlers[:json]
          @handlers[:json].call
        elsif !(@scope.request.xhr?) && @handlers[:html]
          @handlers[:html].call
        end
      end

    end

    def get_pages(query)
      return [1,1] unless query[:page] || query[:pages]
      result = []

      if query[:page]
        result[0] = result[1] = query[:page].to_i
      elsif query[:pages]
        range = query[:pages].split('-')
        if range[1]
          result[0] = range[0].to_i
          result[1] = range[1].to_i
        else
          result[0] = 1
          result[1] = range[0].to_i
        end
      end

      result
    end

    def respond_to(&block)
      format = ResponseWithFormat.new(self)
      yield format
      format.response
    end

    def error_not_found
      respond_to do |format|
        format.html do
          haml :'404'
        end

        format.json do
          content_type :json
          json_status 404, "Not Found"
        end
      end
    end

    def content_for(key, &block)
      @content ||= {}
      @content[key] = capture_haml(&block)
    end

    def content(key)
      @content && @content[key]
    end

    def json_status(code, reason)
      status code
      {
        :status => code,
        :reason => reason
      }.to_json
    end

    def first_login(user)
      load_all_tweets
      load_all_entries(greader_login(settings.glogin))
      user.first_login = false
      user.save!
    end

    def refresh_stars
      refresh_tweets
      refresh_entries(greader_login(settings.glogin))
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
          next if Star.exists?(conditions: { source_id: t.id })
          author = t.user.screen_name
          Star.create!(source: 'twitter',
                       source_id: t.id,
                       image_url: t.user.profile_image_url,
                       author: author,
                       author_url: "http://twitter.com/#{author}",
                       content: linkify_text(t.text,
                                             t.attrs['entities']),
                       ocreated_at: t.created_at)
        end

        page += 1
      end
    end

    def load_all_entries(user)
      entries = greader_starred_items(user)[0]
      entries.each do |e|
        id = e.id.content
        next if Star.exists?(conditions: { source_id: id })
        content =  e.content ? e.content.content : e.summary.content
        title = build_link(e.link.href, e.title.content)
        Star.create!(source: 'greader',
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
          return if Star.exists?(conditions: { source_id: t.id })
          author = t.user.screen_name
          Star.create!(source: 'twitter',
                       source_id: t.id,
                       image_url: t.user.profile_image_url,
                       author: author,
                       author_url: "http://twitter.com/#{author}",
                       content: linkify_text(t.text,
                                             t.attrs["entities"]),
                       ocreated_at: t.created_at)
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
          return if Star.exists?(conditions: { source_id: id})
          content = e.content ? e.content.content : e.summary.content
          title  = build_link(e.link.href, e.title.content)
          Star.create!(source: 'greader',
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
      entities.sort! {|x,y| y["indices"][0] <=> x["indices"][1] }
      entities.each do |entity|
        length = entity["indices"][1] - entity["indices"][0]

        result = case
                 when url = entity["url"]
                   display_url = entity["display_url"] || url
                   build_link(url, display_url)
                 when user = entity["screen_name"]
                   build_link("http://twitter.com/#{user}",
                              '@' + user)
                 when ht = entity["text"]
                   build_link("http://twitter.com/search?q=%23#{ht}",
                              "##{ht}")
                 end

        tweet_text[entity["indices"][0], length] = result
      end

      tweet_text
    end

  end

  helpers StarHelpers

end
