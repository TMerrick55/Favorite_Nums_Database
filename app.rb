require 'sinatra'
require 'pg'

load './local_env.rb' if File.exists?('./local_env.rb')
db_params = {
	host: ENV['host'],
	port: ENV['port'],
	dbname: ENV['db_name'],
	user: ENV['user'],
	password: ENV['password']}
	db = PG::Connection.new(db_params)

	get '/' do
		favnums=db.exec("SELECT first_name, last_name, age, favorite_numbers, favorite_food, favorite_phrase FROM favorite_details_database");
		erb :index, locals: {favnums: favnums}
	end

	post '/favnums' do
		first_name = params[:first_name]
		last_name = params[:last_name]
		age = params[:age]
		favorite_numbers = params[:favorite_numbers]
		favorite_food = params[:favorite_food]
		favorite_phrase = params[:favorite_phrase]

		db.exec("INSERT INTO favorite_details_database (first_name, last_name, age, favorite_numbers, favorite_food, favorite_phrase) VALUES('#{first_name}', '#{last_name}', '#{age}', '#{favorite_numbers}', '#{favorite_food}', '#{favorite_phrase}')");
		redirect '/'
	end

	post '/update_column' do

   new_data = params[:new_data]
   old_data = params[:old_data]
   column = params[:table_column]

   case column

   when 'col_first_name'
   	db.exec("UPDATE favnums SET first_name = '#{new_data}' WHERE first_name = '#{old_data}' ");
   when 'col_last_name'
   	db.exec("UPDATE favnums SET last_name = '#{new_data}' WHERE last_name = '#{old_data}' ");
   when 'col_age'
   	db.exec("UPDATE favnums SET age = '#{new_data}' WHERE age = '#{old_data}' ");
   when 'col_favorite_numbers'
   	db.exec("UPDATE favnums SET favorite_numbers = '#{new_data}' WHERE favorite_numbers = '#{old_data}' ");
   when 'col_favorite_food'
   	db.exec("UPDATE favnums SET favorite_food = '#{new_data}' WHERE favorite_food = '#{old_data}' ");
   when 'col_favorite_phrase'
   	db.exec("UPDATE favnums SET favorite_phrase = '#{new_data}' WHERE favorite_phrase = '#{old_data}' ");
	end
   redirect '/'
end