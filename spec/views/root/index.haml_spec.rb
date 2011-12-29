require 'spec_helper'

describe "/index.haml", :type => :views do

  before :each do
    @stars = []
    @stars << greader_fav
    @stars << twitter_fav
    assigns[:stars] = @stars
    render('/views/index.haml')
  end

  describe 'Basic Skeleton' do

    describe '.about' do

      it 'is a section' do
        response.should have_selector('section.about')
      end

    end

  end

end
