# Courier C# Samples

C# code samples demonstrating how to integrate with Courier's notification platform.

## Prerequisites

- **.NET SDK 10.0 or later** - Required to build and run C# examples
- **Operating System:** Windows, macOS, or Linux

### Verify Prerequisites

Check if .NET SDK is installed:
```bash
dotnet --version
```

If the command is not found, install the .NET SDK (see Quick Start below).

## Quick Start

Get up and running in 3 steps:

1. **Install .NET SDK (if not already installed):**
   
   The .NET SDK is required to build and run C# examples. If you haven't installed it yet:
   
   **macOS/Linux:**
   ```bash
   curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel LTS --install-dir ~/.dotnet
   export PATH="$HOME/.dotnet:$PATH"
   ```
   
   **Windows:**
   Download and install from [.NET Downloads](https://dotnet.microsoft.com/download)
   
   Verify installation:
   ```bash
   dotnet --version
   ```

2. **Restore dependencies:**
   ```bash
   cd server/csharp
   # Dependencies will be restored automatically when you build/run each example
   ```

3. **Set up environment variables:**
   
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

4. **Run with VS Code Debugger:**
   - Open the Run and Debug panel (⇧⌘D or Ctrl+Shift+D)
   - Select a C# configuration from the dropdown (e.g., "C#: Generate JWT")
   - Press F5 or click the play button

The launch configurations will automatically:
- Set up environment variables (via `scripts/set-env.sh`)
- Restore dependencies
- Run the selected script

## Running Scripts Manually

If you prefer to run scripts from the command line:

1. **Navigate to the C# directory:**
   ```bash
   cd server/csharp
   ```

2. **Restore dependencies (first time only):**
   ```bash
   dotnet restore
   ```

3. **Run a sample:**
   
   Each example is in its own directory with its own project file. To run an example:
   ```bash
   cd create-list  # or any other example directory
   dotnet run
   ```
   
   Or from the `server/csharp` directory:
   ```bash
   dotnet run --project create-list/create-list.csproj
   ```

## Available Samples

All 11 C# samples are available (listed alphabetically). Each sample is in its own project directory:

- **`create-list/`** - Create or update a notification list
- **`generate-jwt/`** - Generate JWT tokens for user authentication
- **`get-user-profile/`** - Retrieve a user profile
- **`send-template-to-audience/`** - Send notifications to an audience
- **`send-template-to-email/`** - Send notifications to an email address
- **`send-template-to-list/`** - Send notifications to a list
- **`send-template-to-tenant/`** - Send notifications to a tenant
- **`send-template-to-user-id/`** - Send notifications to a user ID
- **`subscribe-user-to-list/`** - Subscribe a user to a list
- **`unsubscribe-user-from-list/`** - Unsubscribe a user from a list
- **`upsert-user/`** - Create or update a user profile

## Dependencies

The C# samples require:
- **`.NET SDK 10.0`** or later - For building and running C# applications
- **`DotNetEnv`** - For loading environment variables from `.env` files
- **Courier C# SDK** - Automatically initialized as a git submodule

### Courier C# SDK Setup

The Courier C# SDK is included as a git submodule and will be **automatically initialized** when you:
- Run any C# sample from VS Code (via launch configurations)
- Build or run any sample using `dotnet build` or `dotnet run`
- The `Directory.Build.targets` file automatically runs the initialization script before build

If you need to manually initialize the SDK:
```bash
# From the project root
git submodule update --init --recursive server/courier-csharp

# Or use the convenience script
bash server/csharp/init-sdk.sh
```

## Implementation Notes

These C# examples use the **official Courier C# SDK** (https://github.com/trycourier/courier-csharp). The SDK provides:
- Type-safe API methods
- Automatic error handling
- Built-in retry logic
- Strongly-typed request/response models

The examples use:
- `CourierClient` for API interactions
- `Courier.Models.*` for request/response types
- `Courier.Exceptions` for error handling
- `DotNetEnv` for environment variable loading

## Documentation

For complete reference documentation, see:
- [Courier API Documentation](https://www.courier.com/docs)
- [.NET Documentation](https://learn.microsoft.com/dotnet/)
