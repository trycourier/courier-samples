# Courier Node.js Samples

Node.js code samples demonstrating how to integrate with Courier's notification platform.

## Prerequisites

- **Node.js 14.0 or higher** - Required to run Node.js samples
- **npm** - Node package manager (usually included with Node.js)

### Verify Prerequisites

Check if Node.js 14.0+ is installed:
```bash
node --version
```

If the command is not found or shows a version below 14.0, install Node.js 14.0 or higher:
- **macOS (Homebrew):** `brew install node`
- **Linux:** Use [nvm](https://github.com/nvm-sh/nvm) or download from [nodejs.org](https://nodejs.org/)
- **Windows:** Download from [nodejs.org](https://nodejs.org/)

Verify npm is installed:
```bash
npm --version
```

## Quick Start

Get up and running in 3 steps:

1. **Install dependencies:**
   ```bash
   cd server/node
   npm install
   ```

2. **Set up environment variables:**
   
   Create a `.env` file in the `server/` directory (shared across all language examples). You have two options:

   **Option A: Using the interactive script (Recommended)**
   ```bash
   # From the project root, run set-env.sh for the variables you need
   bash scripts/set-env.sh --dir server api_key generate_jwt_user_id
   ```
   The script will prompt you for each variable interactively. If `.env.example` exists, it will be used as a starting point.

   **Option B: Copy from .env.example and edit manually**
   ```bash
   cd server
   cp .env.example .env
   # Then edit .env with your actual values
   ```
   
   The `.env` file should contain variables like:
   ```bash
   COURIER_API_KEY=your_api_key_here
   COURIER_GENERATE_JWT_USER_ID=your_user_id
   COURIER_SEND_TEMPLATE_TO_EMAIL_EMAIL=test@example.com
   COURIER_SEND_TEMPLATE_TO_EMAIL_TEMPLATE_ID=your_template_id
   # ... add other required variables as needed
   ```

3. **Run with VS Code Debugger:**
   - Open the Run and Debug panel (⇧⌘D or Ctrl+Shift+D)
   - Select a Node.js configuration from the dropdown (e.g., "Node.js: Generate JWT")
   - Press F5 or click the play button

The launch configurations will automatically:
- Set up environment variables (via `scripts/set-env.sh`)
- Run the selected script

## Running Scripts Manually

If you prefer to run scripts from the command line:

1. **Navigate to the Node.js directory:**
   ```bash
   cd server/node
   ```

2. **Run a sample:**
   ```bash
   node generate-jwt.js
   ```

## Available Samples

All 11 Node.js samples are available (listed alphabetically):

- **`create-list.js`** - Create or update a notification list
- **`generate-jwt.js`** - Generate JWT tokens for user authentication
- **`get-user-profile.js`** - Retrieve a user profile
- **`send-template-to-audience.js`** - Send notifications to an audience
- **`send-template-to-email.js`** - Send notifications to an email address
- **`send-template-to-list.js`** - Send notifications to a list
- **`send-template-to-tenant.js`** - Send notifications to a tenant
- **`send-template-to-user-id.js`** - Send notifications to a user ID
- **`subscribe-user-to-list.js`** - Subscribe a user to a list
- **`unsubscribe-user-from-list.js`** - Unsubscribe a user from a list
- **`upsert-user.js`** - Create or update a user profile

## Dependencies

The Node.js samples require:
- **`@trycourier/courier`** - Official Courier Node.js SDK
- **`dotenv`** - For loading environment variables from `.env` files

Install with:
```bash
cd server/node
npm install
```

## Documentation

For complete reference documentation, see:
- [Courier Node.js SDK Documentation](https://www.courier.com/docs/sdk-libraries/node)
- [Courier API Documentation](https://www.courier.com/docs)
