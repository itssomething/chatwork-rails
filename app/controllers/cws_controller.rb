class CwsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render html: "index page"
  end

  def create
    # set up token
    ChatWork.api_key = ENV["FRAMGIA_ACCOUNT_TOKEN"]
    # framgia_acc_client = ChatWork::Client.new api_key: ENV["FRAMGIA_ACCOUNT_TOKEN"]
    
    # get room id and body of the message
    room_id = params[:webhook_event][:room_id]
    body = params[:webhook_event][:body]
    
    # case room is Nghiệp Inc chat room, we send message to slack
    if room_id == 116821963
      body = "New message in Nghiệp Inc chat: \n
      #{body}"
      
      uri = URI('https://slack.com/api/chat.postMessage')
      req = Net::HTTP::Post.new(uri)
      
      req['Content-type'] = application/json;charset=utf-8
      req['Authorization'] = ENV["SLACK_BOT_TOKEN"]
      req.set_form_data({"channel": "#general", "text":"<!channel> #{body}"})
      
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      
      render status: 200
    else 
      # find room
      c = ChatWork::Room.find room_id: room_id
      room_name = c.name

      # set up some params
      destination_room_id = ENV["DESTINATION_ROOM_ID"]
      body = "[To:3056978] Vu Duc Manh (private)\nMessage in #{room_name}:\n#{body}"

      # change token to bot's token
      ChatWork.api_key = ENV["BOT_TOKEN"]

      # create message from bot
      ChatWork::Message.create room_id: destination_room_id, body: body
      render status: 200
    end
  end
end
