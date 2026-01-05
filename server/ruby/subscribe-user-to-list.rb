require 'dotenv'
require 'trycourier'

env_path = File.join(File.dirname(__FILE__), '..', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
list_id = ENV['COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID']
user_id = ENV['COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID']

client = Trycourier::Client.new(api_key: api_key)

client.lists.subscriptions.subscribe_user(user_id, list_id: list_id)
