require 'dotenv'
require 'courier'

env_path = File.join(File.dirname(__FILE__), '..', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
audience_id = ENV['COURIER_SEND_TEMPLATE_TO_AUDIENCE_AUDIENCE_ID']
template_id = ENV['COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID']

client = Courier::Client.new(api_key: api_key)

response = client.send_.message(
  message: {
    to: {
      audience_id: audience_id
    },
    template: template_id
  }
)

puts response
