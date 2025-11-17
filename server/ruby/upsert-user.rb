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
user_id = ENV['COURIER_UPSERT_USER_USER_ID']
email = ENV['COURIER_UPSERT_USER_EMAIL']
name = ENV['COURIER_UPSERT_USER_NAME']
phone_number = ENV['COURIER_UPSERT_USER_PHONE_NUMBER']

if api_key.nil? || api_key.empty?
  puts "Error: COURIER_API_KEY environment variable is required"
  exit 1
end

if user_id.nil? || user_id.empty?
  puts "Error: COURIER_UPSERT_USER_USER_ID environment variable is required"
  exit 1
end

# Initialize Courier client using the SDK
client = Courier::Client.new(api_key)

# Build profile object dynamically, only including fields that are set
# Note: All profile fields are optional. If you skip them, an empty profile will be created.
profile = {}
profile[:email] = email if email && !email.empty?
profile[:name] = name if name && !name.empty?
profile[:phone_number] = phone_number if phone_number && !phone_number.empty?

# Create or update user profile using the SDK
begin
  response = client.profiles.replace(
    recipient_id: user_id,
    profile: profile
  )

  # Print response as JSON
  puts JSON.pretty_generate(response)
rescue => e
  puts "Error: #{e.message}"
  exit 1
end
