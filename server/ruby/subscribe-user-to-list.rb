require 'dotenv'
require 'json'
require 'net/http'
require 'uri'

# Load environment variables from .env file in server/curl directory (shared with curl scripts)
env_path = File.join(File.dirname(__FILE__), '..', 'curl', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
list_id = ENV['COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID']
user_id = ENV['COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID']

# Build request body
request_body = {
  preferences: {
    categories: {},
    notifications: {}
  }
}

# Make API request
uri = URI("https://api.courier.com/lists/#{list_id}/subscriptions/#{user_id}")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

request = Net::HTTP::Put.new(uri)
request['Authorization'] = "Bearer #{api_key}"
request['Content-Type'] = 'application/json'
request['Accept'] = 'application/json'
request.body = request_body.to_json

response = http.request(request)

# Handle response
if response.code.to_i >= 200 && response.code.to_i < 300
  if response.body && !response.body.empty?
    puts JSON.pretty_generate(JSON.parse(response.body))
  else
    puts JSON.pretty_generate({
      status: 'success',
      message: 'User subscribed successfully'
    })
  end
else
  begin
    error_response = JSON.parse(response.body)
    puts JSON.pretty_generate(error_response)
  rescue JSON::ParserError
    puts "Error: HTTP #{response.code} - #{response.body}"
  end
  exit 1
end
