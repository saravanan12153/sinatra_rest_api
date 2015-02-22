# app.rb
require 'sinatra'
require 'json'
require 'sinatra/activerecord'
require 'sqlite3'
require './models/init' 
require './routes/init'

db_options = {adapter: 'sqlite3',
              database: 'db/vidkun_starter.sqlite3.db'}
ActiveRecord::Base.establish_connection(db_options)

