class ChatController < WebsocketRails::BaseController
  include ActionView::Helpers::SanitizeHelper

  def initialize_session

  end

  def system_message(event, message)
    broadcast_message event, {
      user_name: 'RedditChat Server',
      subreddit: session[:subreddit].downcase,
      message_body: message
    }
  end

  def user_message(event, message, subreddit)
    puts "received a user message: #{message} on subreddit #{subreddit}"
    broadcast_message event, { 
      user_name: session[:username],
      subreddit: subreddit,
      message_body: ERB::Util.html_escape(message)
    }
  end

  def client_connected
    puts "#{session[:username]} joined #{session[:subreddit]}"
    system_message :new_message, "#{session[:username]} joined #{session[:subreddit]}"
  end

  def new_message
    user_message :new_message, message[:message_body], message[:subreddit]
  end

  def new_user
    connection_store[:user] = { user_name: sanitize(message[:user_name]) }
    system_message :new_message, "#{session[:username]} connected"
    broadcast_user_list
  end

  def delete_user
    system_message :new_message, "#{session[:username]} left #{session[:subreddit]}"
    session.clear
  end

  def broadcast_user_list
    users = connection_store.collect_all(:user)
    broadcast_message :user_list, users
  end
end
