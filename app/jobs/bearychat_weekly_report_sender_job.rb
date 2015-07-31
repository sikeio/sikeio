require 'mechanize'

class BearychatWeeklyReportSenderJob < BearychatMsgSenderJob
  def perform
    text = "本周打卡数: #{Checkin.total_number}, 累计打卡数: #{Checkin.total_number_of_this_week}"
    hook_url = BEARYCHAT_STAFF_GROUP_HOOK_URL
    self.send_message hook_url, '{"text":"' + text + '","markdown":true}'
  end
end
