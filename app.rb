require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS 
	"Users" 
	(
		"id" INTEGER PRIMARY KEY AUTOINCREMENT, 
		"username" TEXT,
		"phone" TEXT, 
		"datestamp" TEXT, 
		"barbername" TEXT, 
		"color" TEXT
	)'
end

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

	hh = {  :username => 'Введите имя', 
			:phone => 'Введите телефон', 
			:datetime => 'Введите дату и время' }

	hh.each do |key, value|

		if params[key] == ''
			@error = hh[key]
			return erb :visit
		end

	end

	db = get_db
	db.execute 'INSERT INTO 
		Users 
		(
			username, 
			phone, 
			datestamp, 
			barbername, 
			color
		) 
		VALUES (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barbername, @color]

	erb "OK!, username is #{@username}, #{@phone}, #{@datetime}, #{@barbername}, #{@color}"

end

get '/showusers' do
	# db = get_db
	# db.results_as_hash = true

 #  	db.execute 'SELECT * FROM Users' do |row|
 #  		puts row['username']
 #  	end
end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end