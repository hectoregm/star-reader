require 'spec_helper'

describe Favorite do

  before(:each) do
    @attributes = { source: "twitter",
      source_id: "2001200",
      image_url: "/images/twitter.png",
      author: "foobarman",
      author_url: "http://twitter.com/foobarman",
      content: "Tweeting from the Golden Gate...",
      ocreated_at: Time.now
    }
  end

  it 'creates a record with valid attributes' do
    fav = Favorite.create(@attributes)
    fav.persisted?.should be_true
  end

  describe 'source' do
    it 'is a required field' do
      @attributes.delete :source
      fav = Favorite.create(@attributes)
      fav.persisted?.should be_false

      fav.errors[:source].size.should == 1
      fav.errors[:source].first.should == 'is an invalid source'
    end

    it 'must be a member of Favorite::SOURCES collection' do
      @attributes[:source] = "bad_source"
      fav = Favorite.create(@attributes)
      fav.persisted?.should be_false

      fav.errors[:source].size.should == 1
      fav.errors[:source].first.should == 'is an invalid source'
    end

  end

  describe 'source_id' do

    it 'is a required field' do
      @attributes.delete :source_id
      fav = Favorite.create(@attributes)
      fav.persisted?.should be_false

      fav.errors[:source_id].size.should == 1
      fav.errors[:source_id].first.should == 'can\'t be blank'
    end

    it 'is unique per source' do
      fav = Favorite.create(@attributes)
      fav2 = Favorite.create(@attributes)
      fav.persisted?.should be_true
      fav2.persisted?.should be_false

      fav2.errors[:source_id].size.should == 1
      fav2.errors[:source_id].first.should == 'is already taken'
    end

  end

  describe 'image_url' do

    it 'is a required field' do
      @attributes.delete :image_url
      fav = Favorite.create(@attributes)
      fav.persisted?.should be_false

      fav.errors[:image_url].size.should == 1
      fav.errors[:image_url].first.should == 'can\'t be blank'
    end

  end

  describe 'author' do

    it 'is a required field' do
      @attributes.delete :author
      fav = Favorite.create(@attributes)
      fav.persisted?.should be_false

      fav.errors[:author].size.should == 1
      fav.errors[:author].first.should == 'can\'t be blank'
    end

  end

  describe 'author_url' do

    it 'is a required field' do
      @attributes.delete :author_url
      fav = Favorite.create(@attributes)
      fav.persisted?.should be_false

      fav.errors[:author_url].size.should == 1
      fav.errors[:author_url].first.should == 'can\'t be blank'
    end

  end

  describe 'title' do

    context 'Non-twitter sources' do

      it 'is a required field' do
        @attributes[:source] = 'greader'
        fav = Favorite.create(@attributes)
        fav.persisted?.should be_false

        fav.errors[:title].size.should == 1
        fav.errors[:title].first.should == 'can\'t be blank'
      end

    end

    context 'Twitter source' do

      it 'is optional' do
        fav = Favorite.create(@attributes)
        fav.persisted?.should be_true
      end

    end

  end

  describe 'content' do

    it 'is a required field' do
      @attributes.delete :content
      fav = Favorite.create(@attributes)
      fav.persisted?.should be_false

      fav.errors[:content].size.should == 1
      fav.errors[:content].first.should == 'can\'t be blank'
    end

  end

  describe 'ocreate_at' do

    it 'is a required field' do
      @attributes.delete :ocreated_at
      fav = Favorite.create(@attributes)
      fav.persisted?.should be_false

      fav.errors[:ocreated_at].size.should == 1
      fav.errors[:ocreated_at].first.should == 'can\'t be blank'
    end

  end

  describe 'archived' do

    it 'has default value of false' do
      fav = Favorite.create(@attributes)
      fav.archived?.should be_false
    end

  end

end
