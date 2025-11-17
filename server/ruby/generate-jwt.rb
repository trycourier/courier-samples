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
user_id = ENV['COURIER_GENERATE_JWT_USER_ID']
expires_in_days = ENV['COURIER_EXPIRES_IN_DAYS'] || '30'

if api_key.nil? || api_key.empty?
  puts "Error: COURIER_API_KEY environment variable is required"
  exit 1
end

if user_id.nil? || user_id.empty?
  puts "Error: COURIER_GENERATE_JWT_USER_ID environment variable is required"
  exit 1
end

# Initialize Courier client using the SDK
client = Courier::Client.new(api_key)

# Build scope string
scope = "user_id:#{user_id} write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands"
expires_in = "#{expires_in_days} days"

# Generate JWT token using the SDK
begin
  response = client.auth_tokens.issue_token(
    scope: scope,
    expires_in: expires_in
  )

  # Print response as JSON
  puts JSON.pretty_generate(response)
rescue => e
  puts "Error: #{e.message}"
  exit 1
end
