# Courier Ruby Examples

Ruby examples for interacting with the Courier API.

## Setup

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Set up environment variables in `../curl/.env` (shared with curl scripts)

3. Run scripts via VS Code debugger or directly:
   ```bash
   ruby create-list.rb
   ```

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
