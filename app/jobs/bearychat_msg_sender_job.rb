require 'rest-client'

# 从后台向bearychat发送消息Job
class BearychatMsgSenderJob < ActiveJob::Base

  BEARYCHAT_STAFF_GROUP_HOOK_URL = ENV['BEARYCHAT_STAFF_GROUP_HOOK_URL']
  BEARYCHAT_ALL_GROUP_HOOK_URL = ENV['BEARYCHAT_ALL_GROUP_HOOK_URL']
  queue_as :default

  # 向bearychat的‘所有人’讨论组发送消息
  def self.send_msg_to_all msg 
    perform_later msg
  end

  # 向bearychat的’内部人员‘讨论组发消息
  def self.send_msg_to_staff msg
    perform_later msg, BEARYCHAT_STAFF_GROUP_HOOK_URL
  end

  def perform(text, hook_url = BEARYCHAT_ALL_GROUP_HOOK_URL)
    data = {text: text, markdown: true}
    self.send_message hook_url, data.to_json
  end

  def send_message url, json_data
    RestClient.post url, json_data, :content_type => :json
  end

end
