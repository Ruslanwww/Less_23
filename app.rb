require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do


	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barbername = params[:barbername]
	@color = params[:colorpicker_regularfont]

	if @username == ''
		@error = 'Введите имя'
		return erb :visit
	end

	erb "OK!, username is #{@username}, #{@phone}, #{@datetime}, #{@barbername}, #{@color}"

end