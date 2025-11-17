require 'dotenv'
require 'json'

# Try to require trycourier gem, install dependencies if missing
begin
  require 'trycourier'
rescue LoadError
  puts "📦 Courier gem not found. Installing dependencies..."
  script_dir = File.dirname(__FILE__)
  Dir.chdir(script_dir) do
    unless system('bundle install --quiet')
      puts "Error: Failed to install dependencies. Please run 'bundle install' manually."
      exit 1
    end
  end
  puts "✓ Dependencies installed"
  # Retry requiring the gem
  require 'trycourier'
end

# Load environment variables from .env file in server directory (shared across all language examples)
env_path = File.join(File.dirname(__FILE__), '..', '.env')
Dotenv.load(env_path)

api_key = ENV['COURIER_API_KEY']
list_id = ENV['COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID']
user_id = ENV['COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID']

if api_key.nil? || api_key.empty?
  puts "Error: COURIER_API_KEY environment variable is required"
  exit 1
end

if list_id.nil? || list_id.empty?
  puts "Error: COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID environment variable is required"
  exit 1
end

if user_id.nil? || user_id.empty?
  puts "Error: COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID environment variable is required"
  exit 1
end

# Initialize Courier client using the SDK
client = Courier::Client.new(api_key)

# Unsubscribe user from list using the SDK
begin
  client.lists.unsubscribe(list_id: list_id, recipient_id: user_id)

  # Print success message since unsubscribe returns void
  response = {
    status: 'success',
    message: 'User unsubscribed successfully'
  }

  puts JSON.pretty_generate(response)
rescue => e
  puts "Error: #{e.message}"
  exit 1
end
