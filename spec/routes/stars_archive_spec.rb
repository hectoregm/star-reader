require 'spec_helper'

describe StarReader do

  def app
    StarReader
  end

  describe "POST /stars/:id/archive" do

    before :each do
      star = greader_fav
      star.save!
      @fav_id = star.id
      star.archived = true
      @fav_json = star.to_json
    end

    it 'should return json' do
      post "/stars/#{@fav_id}/archive"
      last_response.should be_ok
      last_response.content_type.should =~ %r|application/json|
    end

    context 'With valid :id' do

      it 'should return code 200' do
        post "/stars/#{@fav_id}/archive"
        last_response.should be_ok
      end

      it 'should return the archived star as json' do
        post "/stars/#{@fav_id}/archive"
        last_response.body.should == @fav_json
      end

      it 'should archive star' do
        post "/stars/#{@fav_id}/archive"
        star = Star.find(@fav_id)
        star.archived.should be_true
      end

    end

    context 'With invalid :id' do

      it 'should return code 404' do
        post "/stars/123badid/archive"
        last_response.should be_not_found
      end

      it 'should return not found error in json' do
        response_json = { status: 404, reason: "Not Found" }.to_json
        post "/stars/123badid/archive"
        last_response.body.should == response_json
      end

    end

  end

  describe "DELETE /stars/:id/archive" do

    before :each do
      star = greader_fav
      star.archived = true
      star.save!
      @fav_id = star.id
      star.archived = false
      @fav_json = star.to_json
    end

    it 'should return json' do
      delete "/stars/#{@fav_id}/archive"
      last_response.should be_ok
      last_response.content_type.should =~ %r|application/json|
    end

    context 'With valid :id' do

      it 'should return code 200' do
        delete "/stars/#{@fav_id}/archive"
        last_response.should be_ok
      end

      it 'should return the unarchived star as json' do
        delete "/stars/#{@fav_id}/archive"
        last_response.body.should == @fav_json
      end

      it 'should unarchive star' do
        delete "/stars/#{@fav_id}/archive"
        star = Star.find(@fav_id)
        star.archived.should be_false
      end

    end

    context 'With invalid :id' do

      it 'should return code 404' do
        delete "/stars/123badid/archive"
        last_response.should be_not_found
      end

      it 'should return not found error in json' do
        response_json = { status: 404, reason: "Not Found" }.to_json
        post "/stars/123badid/archive"
        last_response.body.should == response_json
      end

    end

  end

end
