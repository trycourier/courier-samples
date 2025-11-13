require 'dotenv'
require 'json'
require 'net/http'
require 'uri'

# Load environment variables from .env file in server directory (shared across all language examples)
env_path = File.join(File.dirname(__FILE__), '..', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
list_id = ENV['COURIER_SEND_TEMPLATE_TO_LIST_LIST_ID']
template_id = ENV['COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID']

# Build request body
request_body = {
  message: {
    to: {
      list_id: list_id
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
