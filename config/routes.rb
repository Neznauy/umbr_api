Rails.application.routes.draw do
  post '/create_post',    to: 'posts#create_post'
  post '/create_rating',  to: 'posts#create_rating'
  post '/get_top_posts',  to: 'posts#get_top_posts'
  get '/get_ip_list',     to: 'posts#get_ip_list'
end
