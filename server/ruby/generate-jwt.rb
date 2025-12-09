require 'dotenv'
require 'trycourier'

env_path = File.join(File.dirname(__FILE__), '..', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
user_id = ENV['COURIER_GENERATE_JWT_USER_ID']
expires_in_days = ENV['COURIER_EXPIRES_IN_DAYS'] || '30'

client = Courier::Client.new(api_key)

response = client.auth_tokens.issue_token(
  scope: "user_id:#{user_id} write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands",
  expires_in: "#{expires_in_days} days"
)

puts response
