require 'dotenv'
require 'trycourier'

env_path = File.join(File.dirname(__FILE__), '..', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
list_id = ENV['COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID']
user_id = ENV['COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID']

client = Courier::Client.new(api_key)

client.lists.subscribe(list_id: list_id, recipient_id: user_id)
