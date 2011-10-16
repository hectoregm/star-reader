require 'spec_helper'

describe Star do

  def app
    Star
  end

  describe "GET /" do

    it 'should show user favorite tweets' do
      get '/'
      last_response.should be_ok
      last_response.body.should have_selector('.tweet')
      last_response.body.should have_selector('.tweet-image')
      last_response.body.should have_selector('.tweet-content')
    end

  end

end
