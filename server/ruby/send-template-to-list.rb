require 'dotenv'
require 'trycourier'

env_path = File.join(File.dirname(__FILE__), '..', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
list_id = ENV['COURIER_SEND_TEMPLATE_TO_LIST_LIST_ID']
template_id = ENV['COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID']

client = Courier::Client.new(api_key)

response = client.send_message({
  message: {
    to: {
      list_id: list_id
    },
    template: template_id
  }
})

puts response
