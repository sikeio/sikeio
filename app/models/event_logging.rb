module EventLogging
  extend self

  LOG_PATH = Rails.root + "log" + "#{Rails.env}_events.jsons"

  # If you let Ruby's Logger to open a file, it would append
  # a stupid header to the very beginning of the log file.
  file = File.open(LOG_PATH,"a")
  file.sync = true
  LOGGER = Logger.new(file)

  LOGGER.formatter = lambda do |severity, datetime, progname, msg|
    msg + "\n"
  end

  def log_event(name,data=nil)
    log = {
      name: name,
      data: data,
      host: ENV["RAILS_HOST"] || "dev",
      timestamp: Time.now.xmlschema
    }
    LOGGER.info(log.to_json)
  end
end