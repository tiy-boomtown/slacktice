require 'rspec'
require_relative '../lib/boomtown/api'

require 'faraday'
require 'json'
require 'dotenv'
Dotenv.load

describe Boomtown::Api do
  it 'can search by min price' do
    api     = Boomtown::Api.from_env
    results = api.search(min_price: 50_000)

    expect(results.count).to be > 5

    results.each do |listing|
      # expect(listing.class).to eq PropertyListing
      expect(listing.price).to be > 50_000
    end
  end

  # api.search(min_price: 50_000, max_price: ...)
end