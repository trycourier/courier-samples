# Courier PHP Examples

PHP examples for interacting with the Courier API.

## Setup

1. Install dependencies:
   ```bash
   composer install
   ```

2. Set up environment variables in `../.env` (shared across all language examples)

3. Run scripts via VS Code debugger or directly:
   ```bash
   php create-list.php
   ```

## Scripts

- `create-list.php` - Create or update a list
- `generate-jwt.php` - Generate JWT tokens for user authentication
- `get-user-profile.php` - Retrieve user profiles
- `send-template-to-email.php` - Send templates to email addresses
- `send-template-to-list.php` - Send templates to lists
- `send-template-to-user-id.php` - Send templates to user IDs
- `send-template-to-audience.php` - Send templates to audiences
- `send-template-to-tenant.php` - Send templates to tenants
- `subscribe-user-to-list.php` - Subscribe users to lists
- `unsubscribe-user-from-list.php` - Unsubscribe users from lists
- `upsert-user.php` - Create or update user profiles with optional fields

## Requirements

- PHP 7.4 or higher
- Composer
- cURL extension (usually included with PHP)
