namespace :tet do
  desc "send notification of how many days till Tet holiday"
  task noti: :environment do
    puts "task run"
    return if Date.today.saturday? || Date.today.sunday?

    # set up some params
    destination_room_id = 116821963
    # group: 116821963
    # personal: 137385942
    days = ("2022/05/01".to_date - Date.today).to_i
    hungking = ("2022/04/10".to_date - Date.today).to_i
    body = "[toall]
Còn #{hungking} ngày nữa là nghỉ giỗ tổ Hùng Vương (rachoa)
Còn #{days} ngày nữa là nghỉ quốc tế lao động (rachoa)
"

    # change token to bot's token
    ChatWork.api_key = ENV["BOT_ACCOUNT_TOKEN"]

    # create message from bot
    ChatWork::Message.create room_id: destination_room_id, body: body
  end
end
