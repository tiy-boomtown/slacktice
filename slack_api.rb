class SlackAPI
  def initialize(token)
    @token = token
  end

  def post(endpoint, parameters={})
    parameters[:token] = @token
    response = Faraday.post "https://slack.com/api/#{endpoint}", parameters

    data = JSON.parse response.body
    unless data['ok']
      raise "#{endpoint} failed: #{data['error']}"
    end
    data
  end
end
