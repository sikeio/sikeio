require 'mechanize'

# 从后台向bearychat发送消息Job
class BearychatMsgSenderJob < ActiveJob::Base

  BEARYCHAT_STAFF_GROUP_HOOK_URL = 'https://hook.bearychat.com/=bw55c/incoming/b361930c7b59ff39b8c7030423fe7d76'
  BEARYCHAT_ALL_GROUP_HOOK_URL = 'https://hook.bearychat.com/=bw55c/incoming/f0e0bbfe349a9db8af8458e49b940e00'
  queue_as :default

  # 当有学员提问时，会点击链接跳转到bbs中，在redirect之前需要向bearychat发送一个消息。
  # text显示的内容为  johnnyhappy365对 css0to1 的 迈出第一步 进行了[提问](http://bbs.sike.io/xcvasdfasdfae)
  # 如：BearychatMsgSenderJob.perform_later "question", "johnnyhappy365对 css0to1 的 迈出第一步 进行了[提问](http://bbs.sike.io/xcvasdfasdfae)"
  # 当有学员提出报名申请邮件时，会点击“订阅迷你课程”，需要向bearychat中发一个消息。
  # 如：BearychatMsgSenderJob.perform_later "subscribe", "johnnyhappy365@gmail.com 发出了迷你课程订阅申请，谁是管事的快处理一下！"
  # type: 'question', 'checkin', 'subscribe'
  def perform(type, text, hook_url = BEARYCHAT_ALL_GROUP_HOOK_URL)
    if type == 'subscribe' || type == 'weekly_stat'
      hook_url = BEARYCHAT_STAFF_GROUP_HOOK_URL
    end
    self.send_message hook_url, '{"text":"' + text + '","markdown":true}'
  end

  def send_message url, json_data
    agent.post url, json_data, {'Content-Type' => 'application/json'}
  end

  def agent
    @agent ||= Mechanize.new
  end
end
