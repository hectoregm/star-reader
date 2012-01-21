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

  describe '#get_pages' do

    context 'no pagination' do

      it 'returns [1,1]' do
        @helpers.get_pages({}).should == [1,1]
      end

    end

    context 'page=<number>' do

      it 'returns [<number>,<number>]' do
        @helpers.get_pages({ page: "10"}).should == [10,10]
      end

    end

    context 'pages=<number>' do

      it 'returns [1, <number>]' do
        @helpers.get_pages({ pages: "6"}).should == [1,6]
      end


    end

    context 'pages=<numberA>-<numberB>' do

      it 'returns [<numberA>, <numberB>]' do
        @helpers.get_pages({ pages: "4-10"}).should == [4,10]
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

    it "should load all stars and update user." do
      @helpers.should_receive(:load_all_tweets).once
      @helpers.should_receive(:load_all_entries).with(anything).once
      @user.should_receive(:first_login=).with(false)
      @user.should_receive(:save!)
      @helpers.first_login(@user)
    end

    it "should save stars" do
      @helpers.first_login(@user)
      Star.where(source: "twitter").count.should == 20
      Star.where(source: "greader").count.should == 5
    end

  end

  describe '#refresh_stars' do

    before :each do
      @user = mock("User")
      @user.stub(:first_login=)
      @user.stub(:save!)
    end

    it 'should update stars from all sources' do
      @helpers.should_receive(:refresh_tweets).once
      @helpers.should_receive(:refresh_entries).with(anything).once
      @helpers.refresh_stars
    end

    it 'should save stars' do
      @helpers.refresh_stars
      Star.where(source: "twitter").count.should == 20
      Star.where(source: "greader").count.should == 15
    end

    context "stars are up to date" do

      it 'should not change the amount of stars' do
        @helpers.first_login(@user)
        Star.where(source: "twitter").count.should == 20
        Star.where(source: "greader").count.should == 5

        @helpers.refresh_stars
        Star.where(source: "twitter").count.should == 40
        Star.where(source: "greader").count.should == 15

        @helpers.refresh_stars
        Star.where(source: "twitter").count.should == 40
        Star.where(source: "greader").count.should == 15
      end

    end

    context 'stars are not up to date' do

      it 'should save new stars' do
        @helpers.first_login(@user)
        Star.where(source: "twitter").count.should == 20
        Star.where(source: "greader").count.should == 5

        @helpers.refresh_stars
        Star.where(source: "twitter").count.should == 40
        Star.where(source: "greader").count.should == 15
      end
    end

  end

end
