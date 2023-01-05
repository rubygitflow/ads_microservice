# frozen_string_literal: true

require_relative 'config/environment'

use Rack::RequestId
use Rack::Ougai::LogRequests, AdsMicroservice.logger # logs every request with timing data, request result, etc.

dev = ENV['RACK_ENV'] == 'development'

run(dev ? Unreloader : AdsMicroservice.freeze.app)

# # We can write this if we only have one route in our microservice
# map '/api/v1/' do
#   run(dev ? Unreloader : AdsMicroservice.freeze.app)
# end
