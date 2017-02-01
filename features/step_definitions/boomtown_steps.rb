Given(/^I'm on the home page$/) do
  @web = Boomtown::Web.new
  @web.visit '/'
end

When(/^I search for "([^"]*)"$/) do |q|
  @web.search_for q
end

Then(/^"([^"]*)" appears in the filter list$/) do |term|
  # tags = @web.find '.bt-search-tags'
  # spans = tags.find_elements css: 'span'
  spans = @web.find_all '.bt-search-tags span'
  tag = spans.find { |s| s.text == "Keyword: \"#{term}\"" }

  expect(tag).not_to eq nil
end

And(/^there are at least (\d+) results$/) do |count|
  results = @web.wait_for '.results-paging'
  expect(results.text.to_i).to be > count.to_i
end

And(/^each result is in (.*)$/) do |location|
  links = @web.find_all 'a.at-related-props-card'
  # a .at-related-props-card - things with class inside a tags
  # a.at-related-props-card - a tags with class ...
  locations = links.map { |l| l.attribute :href }
  pending
end

And(/^I click "Save Search"$/) do
  button = @web.wait_for('a.js-save-search')
  button.click

  # modal = @web.wait_for('.js-sign-in-modal-switcher')
  # expect(modal.text).to include 'Free Account Activation'
end

And(/^I complete registration$/) do
  step "I fill in email"
  step "I fill in name and phone number"
end

And(/^I fill in email$/) do
  @my_email = Faker::Internet.email

  form = @web.find '.js-register-form'
  i = form.find_element(:name, 'email')
  i.send_keys @my_email

  form.find_element(:css, '.bt-squeeze__button').click
end

And(/^I fill in name and phone number/) do
  @my_name  = Faker::Name.name
  @my_phone = Faker::PhoneNumber.phone_number

  form2 = @web.wait_for '.js-complete-register-form'
  i = form2.find_element(:name, 'fullname')
  i.send_keys @my_name

  i = form2.find_element(:name, 'phone')
  i.send_keys @my_phone

  complete = @web.find('button.at-submit-btn')
  complete.click

  # Wait for registration to finish
  # @web.wait.until do
  #   el = @web.find '#complete-register-modal'
  #   !el
  # end
  @web.wait_for 'a.js-signout'
end

And(/^I save the search as "([^"]*)"$/) do |name|
  form = @web.wait_for '#save-search-form'
  i = form.find_element(:name, 'searchName')
  i.send_keys name

  form.find_element(:css, '.at-submit-btn').click
end

Then(/^I see "([^"]*)" in my saved searches$/) do |arg|
  pending
end

And(/^I have a user account$/) do
  pending
end