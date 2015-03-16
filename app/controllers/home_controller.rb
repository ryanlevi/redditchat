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
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    if(@user)
      if(crypt.decrypt_and_verify(@user.password) == params[:password])
        session[:username] = @user.name
        session[:subscribed_subreddits] = []
        redirect_to :root
      end
    end
  end

  def signup_post
    if(User.find_by_name(params[:email]) and params[:email])
      session[:error] = "Account exists!"
      render 'signup'
    elsif(params[:email].match(/\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/) == nil)
      session[:error] = "Invalid email address!"
      render 'signup'
    else
      if(params[:password] == params[:password_kampf])
        @user = User.create(:name => params[:email],
                            :password => params[:password],
                            :reddit => false)
      end
      UserMailer.welcome_email(@user).deliver
      session[:username] = @user.name
      session[:subscribed_subreddits] = []
      redirect_to :root
    end
  end

  def signup
    session[:error] = ""
  end

  def chat
    @r = RedditKit::Client.new
    begin
      if @r.subreddit params[:id]
        session[:subreddit] = params[:id]
      else
        redirect_to :root
      end
    rescue
      redirect_to :root
    end
  end

  def posts
    @r = RedditKit::Client.new
    begin
      if(params[:id].starts_with? "http")
        @link_id = params[:id].match(/(\w|\W)comments.(.*)(\W.)/)[2]
      else
        @link_id = params[:id]
      end
      @post = @r.link "t3_#{@link_id}"
      if @post
        session[:post_title] = @post.title
        session[:post_url] = @post.url
        session[:post_sub] = @post.subreddit
        session[:post_author] = @post.author
      else
        redirect_to :root
      end
    rescue
      redirect_to :root
    end
  end

end
