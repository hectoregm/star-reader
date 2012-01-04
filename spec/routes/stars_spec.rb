require 'spec_helper'

describe StarReader do

  def app
    StarReader
  end

  describe 'GET /stars' do

    context 'HTML Request' do

      it 'returns HTML' do
        get '/stars'
        last_response.should be_ok
        last_response.content_type.should =~ %r|text/html|
      end

      it 'returns code 200' do
        get '/stars'
        last_response.should be_ok
      end

      it 'bootstrap backbone code' do
        get '/stars'
        last_response.body.should match(/StarReader\.init/)
        last_response.body.should match(/"main"/)
      end

    end

    context 'XHR Request' do

      before :each do
        header 'X_REQUESTED_WITH', 'XMLHttpRequest'
      end

      it 'returns json' do
        get '/stars'
        last_response.should be_ok
        last_response.content_type.should =~ %r|application/json|
      end

      it 'returns code 200' do
        get '/stars'
        last_response.should be_ok
      end

      it 'returns an array of json objects for each star' do
        create_stars(2)
        collection_json = Star.unarchived.to_json
        get '/stars'
        last_response.should be_ok
        last_response.body.should == collection_json
      end


      describe 'pagination' do

        it 'returns up to 20 star items per page' do
          create_stars(25)
          page_one_json = Star.unarchived.page(1).to_json
          page_two_json = Star.unarchived.page(2).to_json

          get '/stars'
          last_response.should be_ok
          last_response.body.should == page_one_json
          JSON.parse(last_response.body).should have(20).items

          get '/stars', page: 2
          last_response.should be_ok
          last_response.body.should == page_two_json
          JSON.parse(last_response.body).should have(5).items
        end

        it 'returns an empty array if no data in page' do
          get '/stars'
          last_response.should be_ok
          last_response.body.should == "[]"
        end

      end

    end

  end

  describe 'GET /stars?sort=archived' do

    context 'HTML Request' do

      it 'returns HTML' do
        get '/stars', sort: 'archived'
        last_response.should be_ok
        last_response.content_type.should =~ %r|text/html|
      end

      it 'returns code 200' do
        get '/stars', sort: 'archived'
        last_response.should be_ok
      end

      it 'bootstrap backbone code' do
        get '/stars', sort: 'archived'
        last_response.body.should match(/StarReader\.init/)
        last_response.body.should match(/"archives"/)
      end

    end

    context 'XHR request' do

      before :each do
        header 'X_REQUESTED_WITH', 'XMLHttpRequest'
      end

      it 'returns json' do
        get '/stars', sort: 'archived'
        last_response.should be_ok
        last_response.content_type.should =~ %r|application/json|
      end

      it 'returns code 200' do
        get '/stars', sort: 'archived'
        last_response.should be_ok
      end

      context "No archived items" do

        it 'returns an empty array' do
          create_stars(2)       # Stars non-archived

          get '/stars', sort: 'archived'
          last_response.should be_ok
          last_response.body.should == "[]"
        end

      end

      context "With archived items" do

        it 'returns an array of json objects for each archived star' do
          create_stars(4, true) # Stars archived
          archived_json = Star.archived.to_json

          get '/stars', sort: 'archived'
          last_response.should be_ok
          last_response.body.should == archived_json
          JSON.parse(last_response.body).should have(4).items
        end

      end

    end

  end

  describe "PUT /stars/:id" do

    before :each do
      @star = twitter_fav
      @star.save!
      @star.archived = true
      @star_json = @star.to_json
      @data = { "archived" => true }.to_json
    end

    it 'returns json' do
      put "/stars/#{@star.id}", @data
      last_response.should be_ok
      last_response.content_type.should =~ %r|application/json|
    end

    it 'return code 200' do
      put "/stars/#{@star.id}", @data
      last_response.should be_ok
    end

    it 'returns updated attributes in json' do
      put "/stars/#{@star.id}", @data
      last_response.body.should == @star_json
    end

    context "Invalid ID" do

      it "returns json" do
        json_data = { status: 404, reason: "Not Found" }.to_json
        put "/stars/badid", @data
        last_response.should be_not_found
        last_response.body.should == json_data
      end

      it "returns code 404" do
        put "/stars/badid", @data
        last_response.should be_not_found
      end

    end

  end

end
