require 'spec_helper'

describe Favorite do

  describe "Fields" do

    before(:each) do
      @attributes = { source: "twitter",
        image_url: "/images/twitter.png",
        author: "foobarman",
        content: "Tweeting from the Golden Gate...",
        ocreated_at: Time.now
      }
    end

    it 'should have a source' do
      @attributes.delete :source
      fav = Favorite.create(@attributes)
      fav.persisted?.should be_false
    end

    it 'should have an image url' do
      @attributes.delete :image_url
      fav = Favorite.create(@attributes)
      fav.persisted?.should be_false
    end

    it 'should have an author' do
      @attributes.delete :author
      fav = Favorite.create(@attributes)
      fav.persisted?.should be_false
    end

    it 'should have content' do
      @attributes.delete :content
      fav = Favorite.create(@attributes)
      fav.persisted?.should be_false
    end

    it 'should have a creation time' do
      @attributes.delete :ocreated_at
      fav = Favorite.create(@attributes)
      fav.persisted?.should be_false
    end

    it 'should default to false for archived' do
      fav = Favorite.create(@attributes)
      fav.archived?.should be_false
    end

    it 'should require a title for non-twitter sources' do
      @attributes[:source] = "greader"
      fav = Favorite.create(@attributes)
      fav.persisted?.should be_false
    end

    it 'should not require a title for twitter sources' do
      fav = Favorite.create(@attributes)
      fav.persisted?.should be_true
    end



  end

end
