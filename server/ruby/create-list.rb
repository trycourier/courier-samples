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
list_id = ENV['COURIER_CREATE_LIST_LIST_ID']
list_name = ENV['COURIER_CREATE_LIST_LIST_NAME'] || 'My List Name'

if api_key.nil? || api_key.empty?
  puts "Error: COURIER_API_KEY environment variable is required"
  exit 1
end

if list_id.nil? || list_id.empty?
  puts "Error: COURIER_CREATE_LIST_LIST_ID environment variable is required"
  exit 1
end

# Initialize Courier client using the SDK
client = Courier::Client.new(api_key)

# Create or update list using the SDK
# Note: The Ruby SDK's put method only accepts name, not preferences
begin
  client.lists.put(list_id: list_id, name: list_name)

  # Print success message since put returns void
  response = {
    success: true,
    message: "List '#{list_id}' created/updated successfully",
    list_id: list_id,
    list_name: list_name
  }

  puts JSON.pretty_generate(response)
rescue => e
  puts "Error: #{e.message}"
  exit 1
end
