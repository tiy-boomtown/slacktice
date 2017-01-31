Given(/^I am (\w+)/) do |username|
  puts "You are #{username}"
  token = ENV["#{username.upcase}_TOKEN"]
  unless token # if !token
    raise 'Slack token not set'
  end
  @api = SlackAPI.new token
end

When(/^I send "([^"]*)" to \#(\w+)$/) do |message, channel|
  puts "Sending '#{message}' to ##{channel}"

  # Look up ID for channel
  data       = @api.post 'channels.list'
  channels   = data['channels']
  channel    = channels.select { |c| c['name'] == channel }.first
  channel_id = channel['id']

  puts "channel_id=#{channel_id}"

  # Send message
  @api.post 'chat.postMessage', {
    text:    message,
    channel: channel_id
  }
end

Then(/^I should see "([^"]*)" on the \#(\w+) page$/) do |message, channel|
  # Get channel id
  data       = @api.post 'channels.list'
  channels   = data['channels']
  channel    = channels.select { |c| c['name'] == channel }.first
  channel_id = channel['id']

  data = @api.post 'channels.history', { channel: channel_id }

  last_message = data['messages'].first
  expect(last_message['text']).to eq message
  # expect(last_message['bot_id']).to eq ...
  expect(last_message['ts'].to_i).to be_within(3).of(Time.now.to_i)
end