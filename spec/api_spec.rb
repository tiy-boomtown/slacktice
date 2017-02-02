require 'rspec'
require_relative '../lib/boomtown/api'
require_relative '../lib/boomtown/property_listing'

require 'faraday'
require 'json'
require 'dotenv'
Dotenv.load

describe Boomtown::Api do
  it 'can search by min price' do
    api     = Boomtown::Api.from_env
    results = api.search(min_price: 50_000)

    expect(results.count).to eq 20

    results.each do |listing|
      # expect(listing.class).to eq PropertyListing
      expect(listing.price).to be > 50_000
    end
  end

  it 'can search for max and min' do
    api     = Boomtown::Api.from_env
    results = api.search(min_price: 1_000_000, max_price: 2_000_000)

    expect(results.count).to be > 1

    results.each do |listing|
      expect(listing.price).to be >= 1_000_000
      expect(listing.price).to be <= 2_000_000
    end
  end
end