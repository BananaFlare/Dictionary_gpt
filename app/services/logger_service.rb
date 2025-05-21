class LoggerService
  def self.enabled?
    Rails.application.config.enable_logging == true
  end

  def self.log(level, message)
    return unless enabled?

    Rails.logger.send(level, message)
  end

  def self.info(message)
    log(:info, message)
  end

  def self.debug(message)
    log(:debug, message)
  end

  def self.error(message)
    log(:error, message)
  end
end
