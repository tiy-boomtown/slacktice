Given(/^I am (\w+)/) do |username|
  puts "You are #{username}"
  @token = ENV["#{username.upcase}_TOKEN"]
  unless @token # if !@token
    raise 'Slack token not set'
  end
end

When(/^I send "([^"]*)" to \#(\w+)$/) do |message, channel|
  puts "Sending '#{message}' to ##{channel}"

  # Look up ID for channel
  response = Faraday.post 'https://slack.com/api/channels.list', {
    token: @token
  }
  data = JSON.parse response.body
  unless data['ok']
    raise 'channels.list failed'
  end
  channels   = data['channels']
  channel    = channels.select { |c| c['name'] == channel }.first
  channel_id = channel['id']

  puts "channel id is #{channel_id}"

  # Send message
  Faraday.post 'https://slack.com/api/chat.postMessage', {
    text:    message,
    channel: channel_id,
    token:   @token
  }
end

Then(/^I should see "([^"]*)" on the \#(\w+) page$/) do |message, channel|
  pending
end