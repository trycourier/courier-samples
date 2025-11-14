# Courier Ruby Examples

Ruby examples for interacting with the Courier API.

## Prerequisites

- Ruby 2.6 or higher
- Bundler gem (usually comes with Ruby)

## Setup

1. Install dependencies:
   ```bash
   bundle install --path vendor/bundle
   ```
   
   This installs gems locally in the `vendor/bundle` directory to avoid system-wide conflicts.

2. Set up environment variables in `../.env` (shared across all language examples)

3. Run scripts via VS Code debugger or directly:
   ```bash
   bundle exec ruby create-list.rb
   ```
   
   **Note:** Use `bundle exec` to ensure the correct gem versions are used.

## Scripts

- `create-list.rb` - Create or update a list
- `generate-jwt.rb` - Generate JWT tokens for user authentication
- `get-user-profile.rb` - Retrieve user profiles
- `send-template-to-email.rb` - Send templates to email addresses
- `send-template-to-list.rb` - Send templates to lists
- `send-template-to-user-id.rb` - Send templates to user IDs
- `send-template-to-audience.rb` - Send templates to audiences
- `send-template-to-tenant.rb` - Send templates to tenants
- `subscribe-user-to-list.rb` - Subscribe users to lists
- `unsubscribe-user-from-list.rb` - Unsubscribe users from lists
- `upsert-user.rb` - Create or update user profiles with optional fields
