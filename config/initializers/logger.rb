# frozen_string_literal: true

require_relative '../application'

dev = ENV['RACK_ENV'] == 'development'

logger_path = dev ? $stdout : "#{AdsMicroservice.root}/#{Settings.logger.path}"

AdsMicroservice.configure do |app|
  logger = Ougai::Logger.new(
    logger_path,
    level: Settings.logger.level
  )

  logger.formatter = Ougai::Formatters::Readable.new if dev

  logger.before_log = lambda do |data|
    data[:service] = { name: Settings.app.name }
    data[:request_id] ||= Thread.current[:request_id]
  end

  app.logger = logger
end

Sequel::Model.db.loggers.push(AdsMicroservice.logger)
