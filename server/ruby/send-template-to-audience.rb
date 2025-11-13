require 'dotenv'
require 'json'
require 'net/http'
require 'uri'

# Load environment variables from .env file in server/curl directory (shared with curl scripts)
env_path = File.join(File.dirname(__FILE__), '..', 'curl', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
audience_id = ENV['COURIER_SEND_TEMPLATE_TO_AUDIENCE_AUDIENCE_ID']
template_id = ENV['COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID']

if template_id.nil? || template_id.empty?
  puts "Error: COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID is not set"
  exit 1
end

# Build request body
request_body = {
  message: {
    to: {
      audience_id: audience_id
    },
    template: template_id
  }
}

# Make API request
uri = URI('https://api.courier.com/send')
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
