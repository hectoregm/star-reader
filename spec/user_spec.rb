require 'spec_helper'

describe User do

  describe 'username' do

    it 'is a required field' do
      user = User.create
      user.persisted?.should be_false
    end

    it 'is the key of the collection' do
      user = User.create(username: 'hector')
      user.persisted?.should be_true
      user.id.should == 'hector'
    end

  end

  describe 'first_login' do

    it 'defaults to be true' do
      user = User.create(username: 'hector')
      user.first_login.should be_true
    end

  end

end
