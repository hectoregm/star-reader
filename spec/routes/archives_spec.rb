require 'spec_helper'

describe Star do

  def app
    Star
  end

  describe "GET /archive" do

    it 'should flag as active the Archive tab section' do
      get '/archive'
      last_response.should be_ok
      last_response.body.should have_selector('#archive.active')
    end

    context "No archived items" do

      it 'should say there are no archived favorites' do
        get '/archive'
        last_response.should be_ok
        last_response.body.should have_selector('.star-container .star-stream')
        last_response.body.should have_content('No archived favorites.')
      end

    end

    context "With archived items" do

      before :each do
        favorite = twitter_fav
        favorite.archived = true
        favorite.save!
      end

      it 'should show archived favorites' do
        get '/archive'
        last_response.should be_ok
        last_response.body.should have_selector('.star-container .star-stream')
        last_response.body.should have_selector('.star-item[data-source="twitter"]')
        last_response.body.should_not have_content('No archived favorites.')
        last_response.body.should have_content('Tweet Tweet')
      end

    end

  end

end
