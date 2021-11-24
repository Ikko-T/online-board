require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/cookies'
require 'pg'
require 'digest'
require 'pry'

enable :sessions

# データベース接続設定
agent = PG::connect(
  :host => ENV.fetch("DB_HOST", "localhost"),
  :user => ENV.fetch("DB_USER"),
  :password => ENV.fetch("DB_PASSWORD"),
  :dbname => ENV.fetch("DB_NAME" )
)

# 新規登録
# ==========================>>>
get '/signup' do
  return erb :signup
end

post '/signup' do
  # ユーザー情報取得
  name = params[:name]
  email = params[:email]
  password = params[:password]

  # ユーザー情報登録
  agent.exec_params("INSERT INTO users (name, email, password) VALUES ($1, $2, $3)", [name, email, password])

  # ユーザー取得
  user = agent.exec_params("SELECT * FROM users WHERE email = $1 AND password = $2", [email, password]).to_a.first

  session[:user] = user
  return redirect '/posts'
end
# <<<==========================

# ログイン
# ==========================>>>
get '/login' do
  return erb :login
end

post '/login' do
  email = params[:email]
  password = params[:password]

  # ユーザー取得
  user = agent.exec_params("SELECT * FROM users WHERE email = $1 AND password = $2", [email, password]).to_a.first

  # ユーザー有無の確認
  if user.nil?
    # （ユーザー無しの場合）ログイン画面へ遷移
    return erb :login
  else
    # （ユーザー有りの場合）投稿画面へ遷移
    session[:user] = user
    return redirect '/posts'
  end

end
# <<<==========================

# 投稿
# ==========================>>>
get '/posts' do
  # 投稿データの参照
  @posts = agent.exec_params("SELECT * FROM posts ORDER BY created_at DESC").to_a
  return erb :posts
end

post '/posts' do
  # 投稿入力データの取得
  name = params[:name]
  content = params[:content]

  # 投稿データの登録
  agent.exec_params("INSERT INTO posts (name, content) VALUES ($1, $2)", [name, content])
  return redirect '/posts'
end
# <<<==========================
