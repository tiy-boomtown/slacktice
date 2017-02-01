Given(/^I am (\w+)/) do |username|
  @username = username
  puts "You are #{username}"
  token = ENV.fetch "#{username.upcase}_TOKEN"
  unless token # if !token
    raise 'Slack token not set'
  end
  @api = Slack::Api.new token
  @web = Slack::Web.new
end

When(/^I send a message to \#(\w+)$/) do |channel|
  @message = Faker::Company.catch_phrase
  step "I send \"#{@message}\" to ##{channel}"
end

When(/^I send "([^"]*)" to \#(\w+)$/) do |message, channel|
  puts "Sending '#{message}' to ##{channel}"

  channel_id = @api.id_for_channel channel
  puts "channel_id=#{channel_id}"

  # Send message
  @api.post 'chat.postMessage', {
    text:    message,
    channel: channel_id
  }
end

Then(/^I should see that message on the \#(\w+) page$/) do |channel|
  step "I should see \"#{@message}\" on the ##{channel} page"
end

Then(/^I #(\w+) should have received "([^"]*)"$/) do |channel, text|
  msg = @api.latest_message channel
  expect(msg['text']).to eq text
  expect(msg['ts'].to_i).to be_within(3).of(Time.now.to_i)
  # expect(msg['bot_id']).to eq ...
end

Then(/^I should see "([^"]*)" on the \#(\w+) page$/) do |text, channel|
  @web.select_team
  @web.login_as 'james+test@theironyard.com', ENV.fetch('TESTBOT_PASSWORD')
  @web.join_channel channel

  messages = @web.find_elements(:css, '.message')
  last_message = messages.last

  expect(last_message.text).to include text
end
