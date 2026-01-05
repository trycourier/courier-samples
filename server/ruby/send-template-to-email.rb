require 'dotenv'
require 'trycourier'

env_path = File.join(File.dirname(__FILE__), '..', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
email = ENV['COURIER_SEND_TEMPLATE_TO_EMAIL_EMAIL']
template_id = ENV['COURIER_SEND_TEMPLATE_TO_EMAIL_TEMPLATE_ID']

client = Trycourier::Client.new(api_key: api_key)

response = client.send_.message(
  message: {
    to: {
      email: email
    },
    template: template_id,
    data: {
      name: 'Your Name'
    }
  }
)

puts response
