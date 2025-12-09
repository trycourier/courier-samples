# Courier Go Samples

Go code samples demonstrating how to integrate with Courier's notification platform.

## Prerequisites

- **Go 1.18 or higher** - Required to build and run Go samples
- **Operating System:** Windows, macOS, or Linux

### Verify Prerequisites

Check if Go 1.18+ is installed:
```bash
go version
```

If the command is not found or shows a version below 1.18, install Go 1.18 or higher:
- **macOS (Homebrew):** `brew install go`
- **Linux:** Download from [golang.org](https://go.dev/dl/)
- **Windows:** Download from [golang.org](https://go.dev/dl/)

## Quick Start

Get up and running in 3 steps:

1. **Install dependencies:**
   ```bash
   cd server/go
   go mod download
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
   - Select a Go configuration from the dropdown (e.g., "Go: Generate JWT")
   - Press F5 or click the play button

The launch configurations will automatically:
- Set up environment variables (via `scripts/set-env.sh`)
- Run the selected script

## Running Scripts Manually

If you prefer to run scripts from the command line:

1. **Navigate to the Go directory:**
   ```bash
   cd server/go
   ```

2. **Build and run a sample:**
   ```bash
   go run generate-jwt.go
   ```
   
   Or build first, then run:
   ```bash
   go build -o generate-jwt generate-jwt.go
   ./generate-jwt
   ```

## Available Samples

All 11 Go samples are available (listed alphabetically):

- **`create-list.go`** - Create or update a notification list
- **`generate-jwt.go`** - Generate JWT tokens for user authentication
- **`get-user-profile.go`** - Retrieve a user profile
- **`send-template-to-audience.go`** - Send notifications to an audience
- **`send-template-to-email.go`** - Send notifications to an email address
- **`send-template-to-list.go`** - Send notifications to a list
- **`send-template-to-tenant.go`** - Send notifications to a tenant
- **`send-template-to-user-id.go`** - Send notifications to a user ID
- **`subscribe-user-to-list.go`** - Subscribe a user to a list
- **`unsubscribe-user-from-list.go`** - Unsubscribe a user from a list
- **`upsert-user.go`** - Create or update a user profile

## Dependencies

The Go samples require:
- **`github.com/trycourier/courier-go/v2`** - Official Courier Go SDK
- **`github.com/joho/godotenv`** - For loading environment variables from `.env` files

Dependencies are managed via Go modules and defined in `go.mod`. Install with:
```bash
cd server/go
go mod download
```

## Documentation

For complete reference documentation, see:
- [Courier Go SDK Documentation](https://www.courier.com/docs/sdk-libraries/go)
- [Courier API Documentation](https://www.courier.com/docs)
