require 'dotenv'
require 'courier'

env_path = File.join(File.dirname(__FILE__), '..', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
user_id = ENV['COURIER_SEND_TEMPLATE_TO_USER_ID_USER_ID']
template_id = ENV['COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID']

client = Courier::Client.new(api_key: api_key)

response = client.send_.message(
  message: {
    to: {
      user_id: user_id
    },
    template: template_id,
    data: {
      name: 'Your Name'
    }
  }
)

puts response
