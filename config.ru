# frozen_string_literal: true

require_relative 'config/environment'

dev = ENV['RACK_ENV'] == 'development'

run(dev ? Unreloader : AdsMicroservice.freeze.app)

# # We can write this if we only have one route in our microservice
# map '/api/v1/' do
#   run(dev ? Unreloader : AdsMicroservice.freeze.app)
# end
