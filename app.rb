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

get "/counted/:id/json" do
	@counted = Counted.get params[:id]
	if @counted
		content_type :json
		@counted.graph_json
	else 
		404
	end
end

post "/counted" do
	counted = Counted.new
	counted.name = params[:name]
	counted.save

	if params[:count_options]
		params[:count_options].each do |key, option_name|
			co = counted.count_options.new
			co.name = option_name
			co.save
		end
	content_type :json
	counted.simple_json
	else 
		redirect "/counted/#{counted.id}"

	end

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