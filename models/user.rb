require 'mongoid'

class User
  include Mongoid::Document

  field :username
  field :first_login, type: Boolean, default: true
  key :username
end
