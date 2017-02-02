module Boomtown
  class PropertyListing
    def initialize(data)
      # @price = data.fetch 'ListPrice'
      @data = data
    end

    def price
      @data.fetch 'ListPrice'
    end

    def url
      # "/homes/#{@data.fetch 'Address'}/#{@data.fetch 'City'}/#{@data.fetch 'State'}/..."
      "/homes/#{@data.fetch '_ID'}"
    end
  end
end