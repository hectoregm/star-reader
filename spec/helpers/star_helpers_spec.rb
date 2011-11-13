require 'spec_helper'

describe Sinatra::StarHelpers do

  def app
    Star
  end

  before :all do
    @helpers = Object.new
    @helpers.extend Sinatra::StarHelpers
    class << @helpers
      def settings
        obj = Object.new
        class << obj
          def glogin
            { email: 'foo@bar.com', password: 'foobar'}
          end
        end
        obj
      end
    end
  end

  describe '#first_login' do

    before :each do
      @user = mock("User")
      @user.stub(:first_login=)
      @user.stub(:save!)
      @glogin = { email: 'hectoregm@gmail.com',
        password: '@!*Adept189' }
    end

    it "should load all favorites and update user." do
      @helpers.should_receive(:load_all_tweets).once
      @helpers.should_receive(:load_all_entries).with(anything).once
      @user.should_receive(:first_login=).with(false)
      @user.should_receive(:save!)
      @helpers.first_login(@user)
    end

    it "should save favorites" do
      @helpers.first_login(@user)
      Favorite.where(source: "twitter").count.should == 20
      Favorite.where(source: "greader").count.should == 5
    end

  end

  describe '#refresh_favorites' do

    before :each do
      @user = mock("User")
      @user.stub(:first_login=)
      @user.stub(:save!)
    end

    it 'should update favorites from all sources' do
      @helpers.should_receive(:refresh_tweets).once
      @helpers.should_receive(:refresh_entries).with(anything).once
      @helpers.refresh_favorites
    end

    it 'should save favorites' do
      @helpers.refresh_favorites
      Favorite.where(source: "twitter").count.should == 20
      Favorite.where(source: "greader").count.should == 15
    end

    context "favorites are up to date" do

      it 'should not change the amount of favorites' do
        @helpers.first_login(@user)
        Favorite.where(source: "twitter").count.should == 20
        Favorite.where(source: "greader").count.should == 5

        @helpers.refresh_favorites
        Favorite.where(source: "twitter").count.should == 40
        Favorite.where(source: "greader").count.should == 15

        @helpers.refresh_favorites
        Favorite.where(source: "twitter").count.should == 40
        Favorite.where(source: "greader").count.should == 15
      end

    end

    context 'favorites are not up to date' do

      it 'should save new favorites' do
        @helpers.first_login(@user)
        Favorite.where(source: "twitter").count.should == 20
        Favorite.where(source: "greader").count.should == 5

        @helpers.refresh_favorites
        Favorite.where(source: "twitter").count.should == 40
        Favorite.where(source: "greader").count.should == 15
      end
    end

  end

  describe '#link_author' do

    it 'should build a link to the author' do
      @fav = mock('Favorite')
      @fav.should_receive(:author_url).and_return('http://foo.com')
      @fav.should_receive(:author).and_return('fooman')

      @helpers.link_author(@fav).should == '<a href="http://foo.com">fooman</a>'
    end

  end

  describe '#pretty_time' do

    context 'Between now and 60 seconds ago' do

      it 'should print just now' do
        @helpers.pretty_time(Time.now).should == 'just now'
        @helpers.pretty_time(Time.now - 59).should == 'just now'
      end

    end

    context 'Between 1 and 2 minutes ago' do

      it 'should print a minute ago' do
        @helpers.pretty_time(Time.now - 60).should == 'a minute ago'
        @helpers.pretty_time(Time.now - 119).should == 'a minute ago'
      end

    end

    context 'Between 2 min and 1 hour ago' do

      it 'should print <num> minutes ago' do
        @helpers.pretty_time(Time.now - 120).should == '2 minutes ago'
        @helpers.pretty_time(Time.now - 3599).should == '59 minutes ago'
      end

    end

    context 'Between 1 and 2 hours ago' do

      it 'should print an hour ago' do
        @helpers.pretty_time(Time.now - 3600).should == 'an hour ago'
        @helpers.pretty_time(Time.now - 7199).should == 'an hour ago'
      end

    end

    context 'Between 2 hours and a day ago' do

      it 'should print <num> hours ago' do
        @helpers.pretty_time(Time.now - 7200).should == '2 hours ago'
        @helpers.pretty_time(Time.now - 86399).should == '23 hours ago'
      end

    end

    context 'Between 1 and 2 days ago' do

      it 'should print a day ago' do
        @helpers.pretty_time(Time.now - 86400).should == 'a day ago'
        @helpers.pretty_time(Time.now - 172799).should == 'a day ago'
      end

    end

    context 'Between 2 days and 7 days ago' do

      it 'should print <num> days ago' do
        @helpers.pretty_time(Time.now - 172800).should == '2 days ago'
        @helpers.pretty_time(Time.now - 604799).should == '6 days ago'
      end

    end

    context 'Between 1 and 2 weeks ago' do

      it 'should print a week ago' do
        @helpers.pretty_time(Time.now - 604800).should == 'a week ago'
        @helpers.pretty_time(Time.now - 1209599).should == 'a week ago'
      end

    end

    context 'Between 2 weeks and a month ago' do

      it 'should print <num> weeks ago' do
        @helpers.pretty_time(Time.now - 1209600).should == '2 weeks ago'
        @helpers.pretty_time(Time.now - 2419199).should == '3 weeks ago'
      end

    end

    context 'Between 1 and 2 months ago' do

      it 'should print a month ago' do
        @helpers.pretty_time(Time.now - 2419200).should == 'a month ago'
        @helpers.pretty_time(Time.now - 5270399).should == 'a month ago'
      end

    end

    context 'Between 2 months and a year ago' do

      it 'should print <num> months ago' do
        @helpers.pretty_time(Time.now - 5270400).should == '2 months ago'
        @helpers.pretty_time(Time.now - 31535999).should == '11 months ago'
      end

    end

    context 'Between 1 and 2 year ago' do

      it 'should print a year ago' do
        @helpers.pretty_time(Time.now - 31536000).should == 'a year ago'
        @helpers.pretty_time(Time.now - 63071999).should == 'a year ago'
      end

    end

    context 'Between 2 years and beyond' do

      it 'should print <num> years ago' do
        @helpers.pretty_time(Time.now - 63072000).should == '2 years ago'
        @helpers.pretty_time(Time.now - 150000000).should == '4 years ago'
      end

    end

  end

end
