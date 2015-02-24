class HomeController < ApplicationController
  def index
  end

  def post_reddit_login
    @user = User.find_by_name(params[:username])
    unless(@user)
      @user = User.create(:name => params[:username],
                          :reddit => true)
    end
    @r = RedditKit::Client.new params[:username], params[:password]
    @subscribed_subreddits = {}
    @r.subscribed_subreddits.results.each do |s|
      @subscribed_subreddits[s.name] = s.url
    end
    session[:username] = @r.username
    session[:subscribed_subreddits] = @subscribed_subreddits
    redirect_to :root
  end

  def logout
    session.clear
    redirect_to :root
  end

  def login_post
    @user = User.find_by_name(params[:email])
    if(@user)
      session[:username] = @user.name
      session[:subscribed_subreddits] = []
      redirect_to :root
    end
  end

  def signup_post
    if(User.find_by_name(params[:email]) and params[:email])
      session[:error] = "Account exists!"
      render 'signup'
    else
      if(params[:password] == params[:password_kampf])
        @user = User.create(:name => params[:email],
                            :password => params[:password],
                            :reddit => false)
      end
      session[:username] = @user.name
      session[:subscribed_subreddits] = []
      redirect_to :root
    end
  end
  def signup
    session[:error] = ""
  end
  def chat
    session[:subreddit] = params[:id]
  end
end
