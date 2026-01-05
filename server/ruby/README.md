# Courier Ruby Examples

Ruby examples for interacting with the Courier API.

## Prerequisites

- Ruby 3.2.0 or higher (required for Courier SDK v4)
- Bundler gem (usually comes with Ruby)

**Note:** If you installed Ruby 3.2+ via Homebrew, make sure it's in your PATH:
```bash
export PATH="/usr/local/opt/ruby@3.2/bin:$PATH"
```

Add this to your `~/.zshrc` or `~/.bash_profile` to make it permanent.

## Setup

1. Install dependencies:
   ```bash
   bundle config set path 'vendor/bundle'
   bundle install
   ```
   
   This installs gems locally in the `vendor/bundle` directory to avoid system-wide conflicts.

2. Set up environment variables in `../.env` (shared across all language examples)

3. Run scripts via VS Code debugger or directly:
   ```bash
   bundle exec ruby create-list.rb
   ```
   
   **Note:** Use `bundle exec` to ensure the correct gem versions are used.

## Scripts

### Core API
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

### Bulk API (SDK v4)
- `bulk-create-job-v1.rb` - Create bulk job using V1 format (event mapping)
- `bulk-create-job-v2.rb` - Create bulk job using V2 format (template)
- `bulk-add-users.rb` - Add users to a bulk job
- `bulk-run-job.rb` - Run a bulk job
- `bulk-retrieve-job.rb` - Retrieve bulk job status
- `bulk-list-users.rb` - List users in a bulk job with pagination
- `bulk-complete-workflow.rb` - Complete workflow example (create → add users → run)

**Note:** All samples now use Courier SDK v4, which requires Ruby 3.2.0 or higher.
