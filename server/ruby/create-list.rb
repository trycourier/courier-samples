require 'dotenv'
require 'trycourier'

env_path = File.join(File.dirname(__FILE__), '..', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
list_id = ENV['COURIER_CREATE_LIST_LIST_ID']
list_name = ENV['COURIER_CREATE_LIST_LIST_NAME'] || 'My List Name'

client = Courier::Client.new(api_key)

client.lists.put(list_id: list_id, name: list_name)
