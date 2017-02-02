module Boomtown
  class PropertyListing
    def initialize(data)
      @price = data.fetch 'ListPrice'
    end

    def price
      @price
    end
  end

  class Api

    def self.from_env
      # Boomtown::Api.new(
      new(
         ENV.fetch('BOOMTOWN_USERNAME'),
         ENV.fetch('BOOMTOWN_PASSWORD')
      )
    end

    def initialize(username, password)
      @url   = 'http://flagshipapi.qa6.local/'
      @token = get_token(username, password)
    end

    def send(verb, path, params={})
      conn = Faraday.new @url
      conn.headers['Authorization'] = "Bearer #{@token}"

      response = conn.send verb, path, params
      unless response.status == 200
        raise response.body
      end
      JSON.parse response.body
    end

    def get_token(username, password)
      conn = Faraday.new @url
      conn.basic_auth username, password
      response = conn.post '/oauth/2/token', grant_type: 'client_credentials'
      JSON.parse(response.body).fetch 'access_token'
    end

    def get_lead_id
      # GET flagshipapi.qa6.local/leads/anonymous
      data = send(:get, '/leads/anonymous')
      data['Result']['_ID']
    end

    def get_property_details(prop_id)
      # GET http://flagshipapi.qa6.local/lc/1/listings/3384072
      # ?action=ajax_submit
      # &access_token=...
      # &VisitorID=...
      # &VisitID=...
      # &LogSearch=true
      data = send(:get, "/lc/1/listings/#{prop_id}") # {'LogSearch' => 'true'}
      data['Result']
    end

    def search(criteria)
      data = send(:get, '/lc/1/listings/search')
      results = data['Result']['Items']

      results.map { |hash| PropertyListing.new hash }
    end
  end
end
