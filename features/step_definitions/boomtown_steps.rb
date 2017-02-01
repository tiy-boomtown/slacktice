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

And(/^I click "([^"]*)"$/) do |label|
  links = @web.find_all 'a'
  found = links.find { |l| l.text == label }
  found.click
end

And(/^I complete registration$/) do
  @my_email = Faker::Internet.email
  @my_name  = Faker::Name.name
  @my_phone = Faker::PhoneNumber.phone_number

  form  = @web.wait_for '.js-register-form'
  email = form.find_element name: 'email'
  email.send_keys @my_email

  form.find_element(css: '.bt-squeeze__button').click

  form = @web.wait_for '.js-complete-register-form'
  form.find_element(css: '.at-fullName-txt').send_keys @my_name
  form.find_element(css: '.at-phone-txt').send_keys @my_phone
  form.find_element(css: '.at-complete-registration-btn').click

  # Need to wait for the modal to clear
  @web.wait.until do
    el = @web.find '#complete-register-modal'
    !el || !el.displayed?
  end
end

And(/^I save the search as "([^"]*)"$/) do |name|
  form = @web.find '#save-search-form'
  form.find_element(name: 'searchName').send_keys name
  form.find_element(css: '.at-submit-btn').click
end

Then(/^I see my "([^"]*)" saved search$/) do |name|
  @web.visit '/notifications'
  first_link = @web.find '#searches a'
  expect(first_link.text).to eq name
end

And(/^I have a user account$/) do
  @web.visit '/account'
  phone = @web.find '.at-phone-txt'
  binding.pry
  expect(phone.text).to eq @my_phone
end
