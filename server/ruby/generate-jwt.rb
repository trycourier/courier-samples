require 'dotenv'
require 'json'
require 'net/http'
require 'uri'

# Load environment variables from .env file in server directory (shared across all language examples)
env_path = File.join(File.dirname(__FILE__), '..', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
user_id = ENV['COURIER_GENERATE_JWT_USER_ID']
expires_in_days = ENV['COURIER_EXPIRES_IN_DAYS'] || '30'

# Build request body
request_body = {
  scope: "user_id:#{user_id} write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands",
  expires_in: "#{expires_in_days} days"
}

# Make API request
uri = URI('https://api.courier.com/auth/issue-token')
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

request = Net::HTTP::Post.new(uri)
request['Authorization'] = "Bearer #{api_key}"
request['Content-Type'] = 'application/json'
request['Accept'] = 'application/json'
request.body = request_body.to_json

response = http.request(request)

# Handle response
if response.code.to_i >= 200 && response.code.to_i < 300
  puts JSON.pretty_generate(JSON.parse(response.body))
else
  begin
    error_response = JSON.parse(response.body)
    puts JSON.pretty_generate(error_response)
  rescue JSON::ParserError
    puts "Error: HTTP #{response.code} - #{response.body}"
  end
  exit 1
end
