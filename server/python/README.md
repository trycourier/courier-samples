# Courier Python Samples

Python code samples demonstrating how to integrate with Courier's notification platform.

## Quick Test

To quickly validate all Python samples (syntax and structure):

```bash
cd tests
./quick_test.sh
```

This will check:
- ✅ Python syntax validity
- ✅ Code structure and patterns
- ⚠️ Dependencies (will show as missing if not installed)

## Full Test with Dependencies

To test all samples with dependencies installed in a virtual environment:

```bash
cd tests
./test_with_deps.sh
```

This script will:
1. Create a Python virtual environment (if it doesn't exist)
2. Install required dependencies (`trycourier` and `python-dotenv`)
3. Run comprehensive tests on all samples

## Manual Setup

If you prefer to set up manually:

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

   Or use a virtual environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

2. **Set up environment variables:**
   
   Create a `.env` file in the `server/curl/` directory (shared with curl scripts):
   ```bash
   COURIER_API_KEY=your_api_key_here
   COURIER_GENERATE_JWT_USER_ID=your_user_id
   COURIER_SEND_TEMPLATE_TO_EMAIL_EMAIL=test@example.com
   COURIER_SEND_TEMPLATE_TO_EMAIL_TEMPLATE_ID=your_template_id
   # ... add other required variables as needed
   ```

3. **Run a sample:**
   ```bash
   python3 generate-jwt.py
   ```

## Available Samples

- **`generate-jwt.py`** - Generate JWT tokens for user authentication
- **`send-template-to-email.py`** - Send notifications to an email address
- **`send-template-to-user-id.py`** - Send notifications to a user ID
- **`send-template-to-list.py`** - Send notifications to a list
- **`send-template-to-audience.py`** - Send notifications to an audience
- **`send-template-to-tenant.py`** - Send notifications to a tenant
- **`upsert-user.py`** - Create or update a user profile
- **`get-user-profile.py`** - Retrieve a user profile
- **`create-list.py`** - Create a notification list
- **`subscribe-user.py`** - Subscribe a user to a list
- **`unsubscribe-user.py`** - Unsubscribe a user from a list

## Testing Scripts

All test scripts are located in the `tests/` directory:

- **`tests/test_all.py`** - Python test script that validates all samples
- **`tests/quick_test.sh`** - Quick validation without dependencies
- **`tests/test_with_deps.sh`** - Full test with virtual environment setup

## Documentation

For complete reference documentation, see:
- [Courier Python SDK Documentation](https://www.courier.com/docs/sdk-libraries/python)
- [Courier API Documentation](https://www.courier.com/docs)
