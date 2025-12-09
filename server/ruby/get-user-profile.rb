require 'dotenv'
require 'trycourier'

env_path = File.join(File.dirname(__FILE__), '..', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
user_id = ENV['COURIER_GET_USER_PROFILE_USER_ID']

client = Courier::Client.new(api_key)

response = client.profiles.get(recipient_id: user_id)

puts response
