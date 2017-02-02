Given(/^I'm on the home page$/) do
  @api = Boomtown::Api.new(
    ENV.fetch('BOOMTOWN_USERNAME'),
    ENV.fetch('BOOMTOWN_PASSWORD')
  )
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

And(/^each result mentions (.*)$/) do |phrase|
  links = @web.find_all 'a.at-related-props-card'
  # a .at-related-props-card - things with class inside a tags
  # a.at-related-props-card - a tags with class ...
  links.each do |link|
    href   = link.attribute(:href)
    id     = href.split('/').last
    result = @api.get_property_details id

    puts id
    expect(result['PublicRemarks'].downcase).to include phrase.downcase
  end
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

Then(/^I see "([^"]*)" in my saved searches$/) do |name|
  @web.visit '/notifications'
  first_link = @web.find '#searches a'
  expect(first_link.text).to eq name
end

And(/^I have a user account$/) do
  @web.visit '/account'

  phone = @web.find '.at-phone-txt'
  expect(phone.attribute :value).to eq @my_phone
end

And(/^My agent is located in (\w+)$/) do |city|
  match = /"AgentID":(\d+)/.match(@web.driver.page_source)
  agent_id = match[1].to_i
end

# And(/^I click on the (first|second) property$/) do |ord|
And(/^I click on the (\d+)(st|nd|rd|th) property$/) do |n,_|
  results = @web.wait_for '.js-load-results'
  buttons = results.find_elements css: '.bt-listing-teaser__view-details'
  buttons[n.to_i - 1].click
end

And(/^I go back to search$/) do
  btn = @web.wait.until do
    btns = @web.find_all '.js-back-to-search'
    btns.find { |b| b.displayed? }
  end
  btn.click
end


Then(/^I see a registration form$/) do
  modal = @web.wait_for '.bt-modal__top'
  expect(modal.text).to include 'Want to Compare Homes?'
  expect(modal.text).to include 'Continue With Email'

  # form = modal.find_element css: 'form'
  # expect(form.attribute :action).to eq '...'
end

# Expensive ~> > 1_000_000
When(/^I look at an expensive property$/) do
  prop = @api.search(min_price: 1_000_000).first
  @web.visit prop.url
end

Then(/^I should see at least (\d+) related properties$/) do |n|
  related = @web.wait_for '.bt-related-properties'

  @web.wait_for 'article.bt-listing-teaser'
  props = related.find_elements(css: 'article.bt-listing-teaser')

  # props = @web.wait.until do
  #   found = related.find_elements(css: 'article.bt-listing-teaser')
  #   found if found.count > 0
  # end

  visible_props = props.select { |prop| prop.displayed? }
  expect(visible_props.count).to be >= n.to_i
end