require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require './models'

helpers do

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    user = User.first(:username => "tom")
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [user.username, user.password]
  end

end

get '/' do
	"hello"
end