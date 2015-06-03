class QiniuDeleteFilesJob < ActiveJob::Base
  queue_as :default

  def perform(keys)
    keys.each do |key|
      code, result, response_headers = Qiniu::Storage.delete(
          ENV['QINIU_BUCKET'],
          key
      )
      if code != 200
        EventLogging.log_event "Qiniu-delete-files.error", result
      else
        EventLogging.log_event "Qiniu-delete-files.success", {key: key}
      end
    end
  end
end
