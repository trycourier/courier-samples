require 'dotenv'
require 'json'
require 'net/http'
require 'uri'

# Load environment variables from .env file in server/curl directory (shared with curl scripts)
env_path = File.join(File.dirname(__FILE__), '..', 'curl', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
list_id = ENV['COURIER_CREATE_LIST_LIST_ID']
list_name = ENV['COURIER_CREATE_LIST_LIST_NAME'] || 'My List Name'

# Build request body
request_body = {
  name: list_name,
  preferences: {
    categories: {},
    notifications: {}
  }
}

# Make API request
uri = URI("https://api.courier.com/lists/#{list_id}")
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
  puts JSON.pretty_generate({
    success: true,
    message: "List '#{list_id}' created/updated successfully",
    list_id: list_id,
    list_name: list_name
  })
else
  begin
    error_response = JSON.parse(response.body)
    puts JSON.pretty_generate(error_response)
  rescue JSON::ParserError
    puts "Error: HTTP #{response.code} - #{response.body}"
  end
  exit 1
end
