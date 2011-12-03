require 'spec_helper'

describe StarReader do

  def app
    StarReader
  end

  describe 'GET /' do

    it 'returns html' do
      get '/'
      last_response.should be_ok
      last_response.content_type.should =~ %r|text/html|
    end

    it 'returns code 200' do
      get '/'
      last_response.should be_ok
    end

    it 'has a call to StarReader.init' do
      get '/'
      last_response.body.should match(/StarReader\.init/)
    end

  end

end
