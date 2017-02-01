module Boomtown
  class Api
    attr_reader :conn

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
      data = send(:get, '/leads/anonymous')
      data['Result']['_ID']
    end

    def get_details(property_id)
      # http://flagshipapi.qa6.local/lc/1/listings/1403452?action=ajax_submit&access_token=...&VisitorID=...&VisitID=...&LogSearch=true
      data = send(:get, "/lc/1/listings/#{property_id}")
      data['Result']
    end
  end
end
