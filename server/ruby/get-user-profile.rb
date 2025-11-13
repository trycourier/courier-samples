require 'dotenv'
require 'json'
require 'net/http'
require 'uri'

# Load environment variables from .env file in server directory (shared across all language examples)
env_path = File.join(File.dirname(__FILE__), '..', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
user_id = ENV['COURIER_GET_USER_PROFILE_USER_ID']

# Make API request
uri = URI("https://api.courier.com/profiles/#{user_id}")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

request = Net::HTTP::Get.new(uri)
request['Authorization'] = "Bearer #{api_key}"
request['Accept'] = 'application/json'

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
