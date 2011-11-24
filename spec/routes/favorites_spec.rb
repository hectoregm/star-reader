require 'spec_helper'

describe Star do

  def app
    Star
  end

  describe "GET /favorites" do

    it 'should flag as active the Main tab section' do
      get '/favorites'
      last_response.should be_ok
      last_response.body.should have_selector('#main.active')
    end

    it 'should render the star stream' do
      get '/favorites'
      last_response.should be_ok
      last_response.body.should have_selector('.star-container .star-stream')
      last_response.body.should have_selector('.star-item[data-source="twitter"]')
      last_response.body.should have_selector('.star-item[data-source="greader"]')
    end

    it 'should show up to 20 favorites per page' do
      get '/favorites'
      last_response.should be_ok
      last_response.body.should have_css('.star-item', count: 20)
    end

  end

end
