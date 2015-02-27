class ChatController < WebsocketRails::BaseController
  def initialize_session
    renderer = Redcarpet::Render::HTML.new(filter_html: true)
    controller_store[:markdown] ||= Redcarpet::Markdown.new(renderer)
  end

  def user_message(event, message, channel)
    WebsocketRails[channel].trigger(event, {
      user_name: session[:username],
      received: Time.now.to_s(:short),
      message_body: message,
      channel_name: channel
    })
  end

  def channel_message(event, channel, action)
    WebsocketRails[channel].trigger(event, {
        user_name: 'Server',
        received: Time.now.to_s(:short),
        message_body: "#{connection_store[:user][:handle]} #{action} the channel.",
        channel_name: channel
      })
  end

  def broadcast_public_channels
    all_channels = []
    WebsocketRails.channel_tokens.keys.each do |channel|
      if WebsocketRails[channel].subscribers.size > 0
        all_channels << channel
      end
    end
    broadcast_message(:public_channels, { channels: all_channels })
  end

  def client_connected
    connection_store[:user] = { handle: session[:username] }
    connection_store[:channels] = []
  end

  def new_message
    response_body = controller_store[:markdown].render(message[:message_body])
    response_body = emojify(response_body)
    if response_body.start_with?('<p>') && response_body.chomp.end_with?('</p>')
      response_body = format_message(response_body.chomp[3..-5])
    end
    user_message(:new_message, response_body, message[:channel_name])
  end

  def new_channel_message
    channel_message(:new_message, message[:channel_name], message[:user_action])
    connection_store[:channels] << message[:channel_name]
    broadcast_user_list(message[:channel_name])
    broadcast_public_channels
  end

  def delete_user
    user_channels = []
    connection_store[:channels].each do |channel|
      user_channels << channel
      channel_message(:new_message, channel, "has left")
    end
    connection_store[:user] = nil
    user_channels.each do |channel|
    broadcast_user_list(channel)
    end
  end
end