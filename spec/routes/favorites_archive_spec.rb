require 'spec_helper'

describe Star do

  def app
    Star
  end

  describe "POST /favorites/:id/archive" do

    before :each do
      favorite = greader_fav
      favorite.save!
      @fav_id = favorite.id
      favorite.archived = true
      @fav_json = favorite.to_json
    end

    it 'should return json' do
      post "/favorites/#{@fav_id}/archive"
      last_response.should be_ok
      last_response.content_type.should =~ %r|application/json|
    end

    context 'With valid :id' do

      it 'should return code 200' do
        post "/favorites/#{@fav_id}/archive"
        last_response.should be_ok
      end

      it 'should return the archived favorite as json' do
        post "/favorites/#{@fav_id}/archive"
        last_response.body.should == @fav_json
      end

      it 'should archive favorite' do
        post "/favorites/#{@fav_id}/archive"
        favorite = Favorite.find(@fav_id)
        favorite.archived.should be_true
      end

    end

    context 'With invalid :id' do

      it 'should return code 404' do
        post "/favorites/123badid/archive"
        last_response.should be_not_found
      end

      it 'should return not found error in json' do
        response_json = { status: 404, reason: "Not Found" }.to_json
        post "/favorites/123badid/archive"
        last_response.body.should == response_json
      end

    end

  end

  describe "DELETE /favorites/:id/archive" do

    before :each do
      favorite = greader_fav
      favorite.archived = true
      favorite.save!
      @fav_id = favorite.id
      favorite.archived = false
      @fav_json = favorite.to_json
    end

    it 'should return json' do
      delete "/favorites/#{@fav_id}/archive"
      last_response.should be_ok
      last_response.content_type.should =~ %r|application/json|
    end

    context 'With valid :id' do

      it 'should return code 200' do
        delete "/favorites/#{@fav_id}/archive"
        last_response.should be_ok
      end

      it 'should return the unarchived favorite as json' do
        delete "/favorites/#{@fav_id}/archive"
        last_response.body.should == @fav_json
      end

      it 'should unarchive favorite' do
        delete "/favorites/#{@fav_id}/archive"
        favorite = Favorite.find(@fav_id)
        favorite.archived.should be_false
      end

    end

    context 'With invalid :id' do

      it 'should return code 404' do
        delete "/favorites/123badid/archive"
        last_response.should be_not_found
      end

      it 'should return not found error in json' do
        response_json = { status: 404, reason: "Not Found" }.to_json
        post "/favorites/123badid/archive"
        last_response.body.should == response_json
      end

    end

  end

end
