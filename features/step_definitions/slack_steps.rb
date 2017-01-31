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
  # # Get channel id
  # data       = @api.post 'channels.list'
  # channels   = data['channels']
  # channel    = channels.select { |c| c['name'] == channel }.first
  # channel_id = channel['id']
  #
  # data = @api.post 'channels.history', { channel: channel_id }
  #
  # last_message = data['messages'].first
  # expect(last_message['text']).to eq message
  # # expect(last_message['bot_id']).to eq ...
  # expect(last_message['ts'].to_i).to be_within(3).of(Time.now.to_i)

  Driver.get 'https://slack.com/signin'

  # Select team domain
  team_input = Driver.find_element :id, 'domain'
  team_input.send_keys 'tiy-boomtown'

  Driver.find_element(:id, 'submit_team_domain').click

  # Fill in username and password
  email = Driver.find_element :name, 'email'
  email.send_keys 'james+test@theironyard.com'

  password = Driver.find_element :name, 'password'
  password.send_keys ENV['TESTBOT_PASSWORD']

  buttons = Driver.find_elements :css, 'button'
  sign_in = buttons.select { |b| b.text == 'Sign in' }
  sign_in.click

  # On the home page
  headers = Driver.find_elements :css, 'button.channel_list_header_label'
  headers.select { |b| b.text.start_with? 'CHANNELS' }.click

  # Filter down to see the channel
  Driver.find_element(:id, 'channel_browser_filter').send_keys channel
  link = Driver.find_elements(:css, '.channel_link').first
  link.click

  # Look for the last message
  messages = Driver.find_elements(:css, '.message')
  last_message = messages.last

  expect(last_message.text).to include message
end