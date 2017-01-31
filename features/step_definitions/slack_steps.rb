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
  pending
end