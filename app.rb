require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require './models'

# helpers do

#   def protected!
#     unless authorized?
#       response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
#       throw(:halt, [401, "Not authorized\n"])
#     end
#   end

#   def authorized?
#     @auth ||=  Rack::Auth::Basic::Request.new(request.env)
#     user = User.first(:username => "tom")
#     @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [user.username, user.password]
#   end

# end

get '/' do
	redirect "/counted/new"
end

get "/counted/new" do
	erb :new_counted
end

get "/counted/:id" do
	@counted = Counted.get params[:id]
	if @counted
		erb :show_counted
	else 
		404
	end
end

post "/counted" do
	counted = Counted.new
	counted.name = params[:name]
	counted.save
	redirect "/counted/#{counted.id}"
end

post '/counted/:id/options' do
  @counted = Counted.get params[:id]

  if @counted
  	counted_option = @counted.count_options.new
  	counted_option.name = params[:name]
  	counted_option.save
	redirect "/counted/#{@counted.id}"
  else
  	404
  end
end

post '/counted/:count_id/options/:option_id/ticks' do
  @count_option = CountOption.get params[:option_id]
  if @count_option
  	@count_option.ticks.create
  	redirect "/counted/#{@count_option.counted.id}"
  else
  	404
  end
end