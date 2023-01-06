# frozen_string_literal: true

module AuthService
  module Api
    def auth(token)
      payload = { token: token }.to_json
      publish(payload)
    end
  end
end
