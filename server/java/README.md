# Courier Java Samples

Java code samples demonstrating how to integrate with Courier's notification platform.

## Quick Start

Get up and running in 4 steps:

1. **Install Maven (if not already installed):**
   
   **macOS (Homebrew):**
   ```bash
   brew install maven
   ```
   
   **Linux (apt):**
   ```bash
   sudo apt-get install maven
   ```
   
   **Linux (yum):**
   ```bash
   sudo yum install maven
   ```
   
   **Or download from:** https://maven.apache.org/download.cgi
   
   Verify installation:
   ```bash
   mvn --version
   ```

2. **Set up Maven and install dependencies:**
   ```bash
   cd server/java
   mvn clean install
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
   - Select a Java configuration from the dropdown (e.g., "Java: Generate JWT")
   - Press F5 or click the play button

The launch configurations will automatically:
- Set up environment variables (via `scripts/set-env.sh`)
- Compile the Java code with Maven
- Run the selected script

## Running Scripts Manually

If you prefer to run scripts from the command line:

1. **Navigate to the Java directory:**
   ```bash
   cd server/java
   ```

2. **Compile the project:**
   ```bash
   mvn clean compile
   ```

3. **Run a sample:**
   ```bash
   mvn exec:java -Dexec.mainClass="GenerateJwt"
   ```
   
   Or compile and run directly:
   ```bash
   javac -cp "target/classes:$(mvn dependency:build-classpath -q -Dmdep.outputFile=/dev/stdout)" *.java
   java -cp ".:target/classes:$(mvn dependency:build-classpath -q -Dmdep.outputFile=/dev/stdout)" GenerateJwt
   ```

## Available Samples

All 11 Java samples are available (listed alphabetically):

- **`CreateList.java`** - Create or update a notification list
- **`GenerateJwt.java`** - Generate JWT tokens for user authentication
- **`GetUserProfile.java`** - Retrieve a user profile
- **`SendTemplateToAudience.java`** - Send notifications to an audience
- **`SendTemplateToEmail.java`** - Send notifications to an email address
- **`SendTemplateToList.java`** - Send notifications to a list
- **`SendTemplateToTenant.java`** - Send notifications to a tenant
- **`SendTemplateToUserId.java`** - Send notifications to a user ID
- **`SubscribeUser.java`** - Subscribe a user to a list
- **`UnsubscribeUser.java`** - Unsubscribe a user from a list
- **`UpsertUser.java`** - Create or update a user profile

## Dependencies

The Java samples require:
- **Java 11 or higher** - Minimum runtime for the SDK
- **Maven** - For dependency management
- **`com.courier:courier-java`** - Official Courier Java SDK

Dependencies are managed via Maven and defined in `pom.xml`. Install with:
```bash
cd server/java
mvn clean install
```

## Documentation

For complete reference documentation, see:
- [Courier API Documentation](https://www.courier.com/docs)
- [Courier Java SDK Documentation](https://www.courier.com/docs/sdk-libraries/java)

---

## Testing (For Repository Maintainers)

### Quick Test (Syntax Validation)

To quickly validate all Java samples (syntax and structure):

```bash
cd tests
./quick_test.sh
```

This will check:
- ✅ Java syntax validity
- ✅ Code structure and patterns
- ⚠️ Dependencies (will show as missing if not installed)

### Full Test with Dependencies

To test all samples with dependencies installed via Maven:

```bash
cd tests
./test_with_deps.sh
```

This script will:
1. Compile the Java code with Maven
2. Run comprehensive tests on all samples

All test scripts are located in the `tests/` directory:
- **`tests/TestAll.java`** - Java test script that validates all samples
- **`tests/quick_test.sh`** - Quick validation without dependencies
- **`tests/test_with_deps.sh`** - Full test with Maven compilation
