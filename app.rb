require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers
	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (name) values (?)', [barber]
		end
	end
end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

before do
	db = get_db
	@barbers = db.execute 'select * from Barbers'
end

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

	db.execute 'CREATE TABLE IF NOT EXISTS 
	"Barbers" 
	(
		"id" INTEGER PRIMARY KEY AUTOINCREMENT, 
		"name" TEXT
	)'

	seed_db db, ['Jess', 'Mike', 'Mia', 'Jared', 'Megan']
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

	erb "<h2>Спасибо, вы записаны</h2>"

end

get '/showusers' do
	db = get_db

	@results = db.execute 'select * from Users order by id desc'
	erb :showusers

end

