# frozen_string_literal: true

require 'securerandom'
require 'dry/initializer'
require_relative 'api'

# http://rubybunny.info/articles/queues.html
module AuthService
  class Client
    extend Dry::Initializer[undefined: false]
    include Api

    QUEUE_NAME = 'authentication'

    option :connection, default: proc { create_connection }

    option :lock, default: proc { Mutex.new }
    option :condition, default: proc { ConditionVariable.new }
    option :correlation_id, default: proc { SecureRandom.uuid }

    option :reply_queue, default: proc { create_reply_queue }

    attr_accessor :response, :channel, :exchange

    private

    def create_connection
      connection = Bunny.new(automatically_recover: false)
      connection.start
    end

    def create_reply_queue
      that = self
      @channel = connection.create_channel
      reply_queue = channel.queue('', exclusive: true)
      reply_queue.subscribe do |_delivery_info, properties, payload|
        if properties[:correlation_id] == that.correlation_id
          that.response = payload.to_i

          # sends the signal to continue the execution of .publish
          that.lock.synchronize { that.condition.signal }
        end
      end
      reply_queue
    end

    def publish(payload)
      @exchange = channel.default_exchange
      exchange.publish(
        payload,
        routing_key: QUEUE_NAME,
        correlation_id: correlation_id,
        reply_to: reply_queue.name,
        headers: {
          request_id: Thread.current[:request_id]
        }
      )
      lock.synchronize { condition.wait(lock) }
      connection.close
      response
    end
  end
end
