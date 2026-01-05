require 'dotenv'
require 'trycourier'

env_path = File.join(File.dirname(__FILE__), '..', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
tenant_id = ENV['COURIER_SEND_TEMPLATE_TO_TENANT_TENANT_ID']
template_id = ENV['COURIER_SEND_TEMPLATE_TO_TENANT_ID_TEMPLATE_ID']

client = Trycourier::Client.new(api_key: api_key)

response = client.send_.message(
  message: {
    to: {
      tenant_id: tenant_id
    },
    template: template_id
  }
)

puts response
