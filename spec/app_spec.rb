require 'spec_helper'

describe Star do

  def app
    Star
  end

  it "should be alive" do
    get '/'
    last_response.should be_ok
    #last_response.body.should == 'Hello World'
  end
end
