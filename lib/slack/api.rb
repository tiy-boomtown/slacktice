module Slack
  class Api
    def initialize(token)
      @token = token
    end

    def post(endpoint, parameters={})
      parameters[:token] = @token
      response = Faraday.post "https://slack.com/api/#{endpoint}", parameters

      data = JSON.parse response.body
      unless data['ok']
        raise "#{endpoint} failed: #{data['error']}"
      end
      data
    end

    def id_for_channel(channel_name)
      data  = post 'channels.list'
      found = data['channels'].find { |chan| chan['name'] == channel_name }
      found && found['id'] # return `nil` if nothing is found
    end

    def recent_messages(channel_name)
      id   = id_for_channel channel_name
      data = post 'channels.history', { channel: id }
      data['messages']
    end

    def latest_message(channel_name)
      recent_messages(channel_name).first
    end
  end
end
