require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/cookies'

get '/posts' do
  return erb :posts
end

post '/posts' do
  return erb :posts
end
