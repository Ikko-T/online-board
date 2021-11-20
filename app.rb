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

# 投稿画面へ遷移
get '/posts' do
  # データの参照
  @posts = agent.exec_params("SELECT * FROM posts ORDER BY created_at DESC").to_a
  return erb :posts
end

# 投稿画面
post '/posts' do
  # 入力データの取得
  name = params[:name]
  content = params[:content]

  # データの登録
  agent.exec_params("INSERT INTO posts (name, content) VALUES ($1, $2)", [name, content])
  # binding.pry
  return redirect '/posts'
end
