require 'mongoid'

class Favorite
  include Mongoid::Document
  include Mongoid::Timestamps

  field :source
  field :image_url
  field :author
  field :title
  field :content
  field :ocreated_at, type: DateTime
  field :archived, type: Boolean, default: false
  validates_presence_of :source, :image_url, :author
  validates_presence_of :content, :ocreated_at
  validates_presence_of :title,
                        if: lambda { |o| o.source != 'twitter' }
end
