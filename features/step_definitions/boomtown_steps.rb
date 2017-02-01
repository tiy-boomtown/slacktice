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
  locations = links.map { |l| l.attribute :href }
  locations.each do |l|
    id = l.split('/').last
    deets = @api.get_details id
    expect(deets['PublicRemarks'].downcase.include? phrase.downcase)
  end
end
