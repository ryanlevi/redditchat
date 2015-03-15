Rails.application.routes.draw do
  get 'home/index'

  get 'home/chat'
  get 'r/:id', to:'home#chat'

  get 'home/login'
  get 'login', to: 'home#login'

  post 'home/login_post'
  post 'login', to: 'home#login_post'

  get 'home/reddit_login'
  get 'reddit_login', to: 'home#reddit_login'

  post 'home/post_reddit_login'
  post 'reddit_login', to: 'home#post_reddit_login'

  get 'home/signup'
  get 'signup', to: 'home#signup'

  post 'home/signup_post'
  post 'signup', to: 'home#signup_post'
  
  get 'home/logout'
  get 'logout', to: 'home#logout'

  get 'home/posts'
  get 'posts/:id', to: 'home#posts'

  root 'home#index'

end
