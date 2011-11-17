require 'spec_helper'

describe "/index.haml", :type => :views do

  before :each do
    @favorites = []
    @favorites << greader_fav
    @favorites << twitter_fav
    assigns[:favorites] = @favorites
    render('/views/index.haml')
  end

  describe '.star-item' do

    it 'has an image' do
      response.should have_selector('.star-item .star-image img')
    end

    it 'has a content box' do
      response.should have_selector('.star-item .star-content')
    end

    it 'has an author' do
      response.should have_selector('.star-item .star-content .star-author')
    end

    it 'has text' do
      response.should have_selector('.star-item .star-content .star-text')
    end

    it 'has a timestamp' do
      response.should have_selector('.star-item .star-content .star-timestamp')
    end

    it 'has an archive action' do
      response.should have_selector('.star-item .star-action[data-action=archive]')
    end

    it 'has a data-source attribute' do
      response.should have_selector('.star-item[data-source="twitter"]')
      response.should have_selector('.star-item[data-source="greader"]')
    end

  end

end
