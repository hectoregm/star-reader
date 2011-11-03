require 'spec_helper'

describe Star do

  def app
    Star
  end

  describe '.star-item' do

    it 'has an image' do
      get '/'
      last_response.should be_ok
      last_response.body.should have_selector('.star-item .star-image img')
    end

    it 'has a content box' do
      get '/'
      last_response.should be_ok
      last_response.body.should have_selector('.star-item .star-content')
    end

    it 'has an author' do
      get '/'
      last_response.should be_ok
      last_response.body.should have_selector('.star-item .star-content .star-author')
    end

    it 'has text' do
      get '/'
      last_response.should be_ok
      last_response.body.should have_selector('.star-item .star-content .star-text')
    end

    it 'has a timestamp' do
      get '/'
      last_response.should be_ok
      last_response.body.should have_selector('.star-item .star-content .star-timestamp')
    end

    it 'has an archive action' do
      get '/'
      last_response.should be_ok
      last_response.body.should have_selector('.star-item .star-action.archive')
    end

    it 'has a data-source attribute' do
      get '/'
      last_response.should be_ok
      last_response.body.should have_selector('.star-item[data-source="twitter"]')
      last_response.body.should have_selector('.star-item[data-source="greader"]')
    end

  end

end
