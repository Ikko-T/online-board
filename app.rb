require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/cookies'
require 'pg'
require 'pry'

agent = PG::connect(
  :host => ENV.fetch("DB_HOST", "localhost"),
  :user => ENV.fetch("DB_USER"),
  :password => ENV.fetch("DB_PASSWORD"),
  :dbname => ENV.fetch("DB_NAME" )
)

get '/posts' do
  return erb :posts
end

post '/posts' do
  return erb :posts
end
