require 'dotenv'
require 'trycourier'

env_path = File.join(File.dirname(__FILE__), '..', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
user_id = ENV['COURIER_UPSERT_USER_USER_ID']
email = ENV['COURIER_UPSERT_USER_EMAIL']
name = ENV['COURIER_UPSERT_USER_NAME']
phone_number = ENV['COURIER_UPSERT_USER_PHONE_NUMBER']

client = Trycourier::Client.new(api_key: api_key)

profile = {}
profile[:email] = email if email && !email.empty?
profile[:name] = name if name && !name.empty?
profile[:phone_number] = phone_number if phone_number && !phone_number.empty?

response = client.profiles.create(user_id, profile: profile)

puts response
