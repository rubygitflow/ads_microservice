# frozen_string_literal: true

require 'json'

class AdsMicroservice < Roda
  class << self
    attr_accessor :logger

    def root
      ApplicationLoader.root
    end
  end

  def logger
    AdsMicroservice.logger
  end

  # https://github.com/jeremyevans/rack-unreloader#classes-split-into-multiple-files-
  Unreloader.require 'app/helpers'
  Unreloader.require 'app/serializers'

  # https://roda.jeremyevans.net/documentation.html
  plugin :environments
  plugin :hash_routes
  plugin :typecast_params
  plugin :json
  plugin :all_verbs

  plugin :default_headers,
         # 'Strict-Transport-Security'=>'max-age=16070400;', # Uncomment if only allowing https:// access
         'Content-Type' => 'application/json'

  plugin :not_found do
    {}
  end

  # https://roda.jeremyevans.net/rdoc/classes/Roda/RodaPlugins/ErrorHandler.html
  plugin :error_handler do |_e|
    request.redirect '../app/routes/api/v1/errors_handler.rb'
  end

  # use Rack::Session::Cookie, secret: 'some_nice_long_random_string_DSKJH4378EYR7EGKUFH', key: '_roda_app_session'
  plugin :sessions,
         key: '_AdsMicroservice.session',
         # cookie_options: {secure: ENV['RACK_ENV'] != 'test'}, # Uncomment if only allowing https:// access
         secret: ENV.send((ENV['RACK_ENV'] == 'development' ? :[] : :delete), 'ADS_MICROSERVICE_SESSION_SECRET')

  Unreloader.require('app/routes', delete_hook: proc { |f| hash_branch(File.basename(f).delete_suffix('.rb')) }) {}

  route do |r|
    r.root do
      { status: :ok, message: I18n.t('hello'), page_size: Settings.pagination.page_size }
    end
    r.hash_routes
  end
end
