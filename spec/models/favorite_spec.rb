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

  describe 'pagination' do

    describe '.per_page' do

      it 'returns the number of favs per page. Default is 20' do
        Favorite.per_page.should == 20
      end

    end

    describe '#page' do

      before :each do
        create_favorites(25)
      end

      it 'returns the favorites for the n page' do
        Favorite.per_page = 10
        Favorite.page(1).to_a.should have(10).items
        Favorite.page(2).to_a.should have(10).items
        Favorite.page(3).to_a.should have(5).items
        Favorite.per_page = 20
      end

    end

  end

  describe 'default_scope' do

    it 'should order results in desc order for ocreated_at' do
      create_favorites(3)
      fav_first, fav_second, fav_third = Favorite.all

      fav_first.ocreated_at.should > fav_second.ocreated_at
      fav_second.ocreated_at.should > fav_third.ocreated_at
      fav_first.ocreated_at.should > fav_third.ocreated_at
    end

  end

  describe 'archived' do

    it 'scopes queries to favorites that are archived' do
      create_favorites(3)
      Favorite.archived.to_a.should be_empty
      fav = Favorite.first
      fav.update_attribute(:archived, true)
      Favorite.archived.to_a.should have(1).items
    end

  end

  describe 'unarchived' do

    it 'scopes queries to non-archived favorites' do
      create_favorites(3)
      Favorite.unarchived.to_a.should have(3).items
      fav = Favorite.first
      fav.update_attribute(:archived, true)
      Favorite.unarchived.to_a.should have(2).items
    end

  end

end
