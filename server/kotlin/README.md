# Courier Kotlin Examples

Kotlin examples for interacting with the Courier API.

## Prerequisites

- **Kotlin** - Install via Homebrew (`brew install kotlin`) or [SDKMAN](https://sdkman.io/)
- **Java 8 or higher** - Kotlin requires Java Runtime Environment (JRE)

### Verify Prerequisites

1. Check Kotlin installation:
   ```bash
   kotlinc -version
   ```

2. Check Java installation:
   ```bash
   java -version
   ```

3. Set JAVA_HOME (macOS/Linux):
   ```bash
   # macOS
   export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
   
   # Linux (adjust path based on your Java installation)
   export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
   ```

   **Note:** Add this to your `~/.bashrc` or `~/.zshrc` to make it permanent.

## Setup

1. Set up environment variables in `../.env` (shared across all language examples)

2. Run scripts via VS Code debugger or directly:
   ```bash
   # Make sure JAVA_HOME is set (see Prerequisites above)
   export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
   export PATH="$JAVA_HOME/bin:$PATH"
   
   # Compile and run
   kotlinc create-list.kt -include-runtime -d create-list.jar
   java -jar create-list.jar
   rm -f create-list.jar
   ```

## Scripts

- `create-list.kt` - Create or update a list
- `generate-jwt.kt` - Generate JWT tokens for user authentication
- `get-user-profile.kt` - Retrieve user profiles
- `send-template-to-email.kt` - Send templates to email addresses
- `send-template-to-list.kt` - Send templates to lists
- `send-template-to-user-id.kt` - Send templates to user IDs
- `send-template-to-audience.kt` - Send templates to audiences
- `send-template-to-tenant.kt` - Send templates to tenants
- `subscribe-user-to-list.kt` - Subscribe users to lists
- `unsubscribe-user-from-list.kt` - Unsubscribe users from lists
- `upsert-user.kt` - Create or update user profiles with optional fields

## Requirements

- Kotlin (installed via Homebrew or SDKMAN)
- Java 8 or higher
- Standard Kotlin/Java libraries (no external dependencies required)
