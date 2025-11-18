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
   kotlinc CreateList.kt -include-runtime -d CreateList.jar
   java -jar CreateList.jar
   rm -f CreateList.jar
   ```

## Scripts

- `CreateList.kt` - Create or update a list
- `GenerateJwt.kt` - Generate JWT tokens for user authentication
- `GetUserProfile.kt` - Retrieve user profiles
- `SendTemplateToEmail.kt` - Send templates to email addresses
- `SendTemplateToList.kt` - Send templates to lists
- `SendTemplateToUserId.kt` - Send templates to user IDs
- `SendTemplateToAudience.kt` - Send templates to audiences
- `SendTemplateToTenant.kt` - Send templates to tenants
- `SubscribeUserToList.kt` - Subscribe users to lists
- `UnsubscribeUserFromList.kt` - Unsubscribe users from lists
- `UpsertUser.kt` - Create or update user profiles with optional fields

## Requirements

- Kotlin (installed via Homebrew or SDKMAN)
- Java 8 or higher
- Standard Kotlin/Java libraries (no external dependencies required)
