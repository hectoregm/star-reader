require 'spec_helper'

describe Star do

  def app
    Star
  end

  describe "GET /" do

    it 'should render the star stream' do
      get '/'
      last_response.should be_ok
      last_response.body.should have_selector('.star-container .star-stream')
      last_response.body.should have_selector('.star-item[data-source="twitter"]')
      last_response.body.should have_selector('.star-item[data-source="greader"]')
    end

  end

end
