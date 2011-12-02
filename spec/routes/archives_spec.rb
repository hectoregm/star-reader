require 'spec_helper'

describe StarReader do

  def app
    StarReader
  end

  describe "GET /archive" do

    it 'should flag as active the Archive tab section' do
      get '/archive'
      last_response.should be_ok
      last_response.body.should have_selector('#archive.active')
    end

    context "No archived items" do

      it 'should say there are no archived stars' do
        get '/archive'
        last_response.should be_ok
        last_response.body.should have_selector('.star-container .star-stream')
        last_response.body.should have_content('No archived stars.')
      end

    end

    context "With archived items" do

      before :each do
        star = twitter_fav
        star.archived = true
        star.save!
      end

      it 'should show archived stars' do
        get '/archive'
        last_response.should be_ok
        last_response.body.should have_selector('.star-container .star-stream')
        last_response.body.should have_selector('.star-item[data-source="twitter"]')
        last_response.body.should_not have_content('No archived stars.')
        last_response.body.should have_content('Tweet Tweet')
      end

    end

  end

end
