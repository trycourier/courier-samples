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
tenant_id = ENV['COURIER_SEND_TEMPLATE_TO_TENANT_TENANT_ID']
template_id = ENV['COURIER_SEND_TEMPLATE_TO_TENANT_ID_TEMPLATE_ID']

if api_key.nil? || api_key.empty?
  puts "Error: COURIER_API_KEY environment variable is required"
  exit 1
end

if tenant_id.nil? || tenant_id.empty?
  puts "Error: COURIER_SEND_TEMPLATE_TO_TENANT_TENANT_ID environment variable is required"
  exit 1
end

if template_id.nil? || template_id.empty?
  puts "Error: COURIER_SEND_TEMPLATE_TO_TENANT_ID_TEMPLATE_ID environment variable is required"
  exit 1
end

# Initialize Courier client using the SDK
client = Courier::Client.new(api_key)

# Send message to tenant using the SDK
begin
  response = client.send_message({
    message: {
      to: {
        tenant_id: tenant_id
      },
      template: template_id
    }
  })

  # Print response as JSON
  puts JSON.pretty_generate({
    code: response.code,
    request_id: response.request_id
  })
rescue => e
  puts "Error: #{e.message}"
  exit 1
end
