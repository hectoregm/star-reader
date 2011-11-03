require 'spec_helper'

describe Star do

  def app
    Star
  end

  describe "GET /" do

    context "First Login" do

      before :each do
        User.destroy_all
        User.create!(username: "hector")
      end

      it 'shows user favorites' do
        get '/'
        last_response.should be_ok
        last_response.body.should have_selector('.star-item')
      end

    end

    context "After first login" do

      it 'shows user favorites' do
        get '/'
        last_response.should be_ok
      end

    end

  end

end
