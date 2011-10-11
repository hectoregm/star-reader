require "sinatra/base"
require "sinatra/reloader" if development?
require "twitter"

class Star < Sinatra::Base

  get '/' do
    'Star'
  end

end
