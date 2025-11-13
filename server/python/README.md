# Courier Python Samples

Python code samples demonstrating how to integrate with Courier's notification platform.

## Quick Start

Get up and running in 3 steps:

1. **Set up the virtual environment and install dependencies:**
   ```bash
   cd server/python
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
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
   - Select a Python configuration from the dropdown (e.g., "Python: Generate JWT")
   - Press F5 or click the play button

The launch configurations will automatically:
- Set up environment variables (via `scripts/set-env.sh`)
- Activate the virtual environment
- Run the selected script

## Running Scripts Manually

If you prefer to run scripts from the command line:

1. **Navigate to the Python directory:**
   ```bash
   cd server/python
   ```

2. **Activate the virtual environment:**
   ```bash
   # On macOS/Linux:
   source venv/bin/activate
   
   # On Windows:
   venv\Scripts\activate
   ```
   You should see `(venv)` in your terminal prompt when activated.

3. **Run a sample:**
   ```bash
   python generate-jwt.py
   ```
   
   **Note:** Always activate the virtual environment before running scripts.

## Available Samples

All 11 Python samples are available (listed alphabetically):

- **`create-list.py`** - Create or update a notification list
- **`generate-jwt.py`** - Generate JWT tokens for user authentication
- **`get-user-profile.py`** - Retrieve a user profile
- **`send-template-to-audience.py`** - Send notifications to an audience
- **`send-template-to-email.py`** - Send notifications to an email address
- **`send-template-to-list.py`** - Send notifications to a list
- **`send-template-to-tenant.py`** - Send notifications to a tenant
- **`send-template-to-user-id.py`** - Send notifications to a user ID
- **`subscribe-user-to-list.py`** - Subscribe a user to a list
- **`unsubscribe-user-from-list.py`** - Unsubscribe a user from a list
- **`upsert-user.py`** - Create or update a user profile

## Dependencies

The Python samples require:
- **`courier`** - Official Courier Python SDK
- **`python-dotenv`** - For loading environment variables from `.env` files

Install with:
```bash
cd server/python
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

## Documentation

For complete reference documentation, see:
- [Courier Python SDK Documentation](https://www.courier.com/docs/sdk-libraries/python)
- [Courier API Documentation](https://www.courier.com/docs)

---

## Testing (For Repository Maintainers)

### Quick Test (Syntax Validation)

To quickly validate all Python samples (syntax and structure):

```bash
cd tests
./quick_test.sh
```

This will check:
- ✅ Python syntax validity
- ✅ Code structure and patterns
- ⚠️ Dependencies (will show as missing if not installed)

### Full Test with Dependencies

To test all samples with dependencies installed in a virtual environment:

```bash
cd tests
./test_with_deps.sh
```

This script will:
1. Create a Python virtual environment (if it doesn't exist)
2. Install required dependencies (`courier` and `python-dotenv`)
3. Run comprehensive tests on all samples

All test scripts are located in the `tests/` directory:
- **`tests/test_all.py`** - Python test script that validates all samples
- **`tests/quick_test.sh`** - Quick validation without dependencies
- **`tests/test_with_deps.sh`** - Full test with virtual environment setup
