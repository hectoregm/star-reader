require 'spec_helper'

describe StarReader do

  def app
    StarReader
  end

  describe "GET /stars" do

    it 'should flag as active the Main tab section' do
      get '/stars'
      last_response.should be_ok
      last_response.body.should have_selector('#main.active')
    end

    it 'should render the star stream' do
      get '/stars'
      last_response.should be_ok
      last_response.body.should have_selector('.star-container .star-stream')
      last_response.body.should have_selector('.star-item[data-source="twitter"]')
      last_response.body.should have_selector('.star-item[data-source="greader"]')
    end

    it 'should show up to 20 star items per page' do
      get '/stars'
      last_response.should be_ok
      last_response.body.should have_css('.star-item', count: 20)
    end

  end

end
