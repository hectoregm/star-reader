require 'mongoid'

class Favorite
  include Mongoid::Document
  include Mongoid::Timestamps

  SOURCES = %w{ twitter greader }

  field :source_id
  field :source
  field :image_url
  field :author
  field :author_url
  field :title
  field :content
  field :ocreated_at, type: DateTime
  field :archived, type: Boolean, default: false
  validates_presence_of :image_url, :author, :author_url
  validates_presence_of :content, :ocreated_at, :source_id
  validates_presence_of :title,  :if => lambda { |o| o.source != 'twitter' }
  validates_inclusion_of :source, in: SOURCES, message: 'is an invalid source'
  validates_uniqueness_of :source_id, scope: :source
 end
