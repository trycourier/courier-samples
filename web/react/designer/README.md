# Courier React Designer

## Run the app

There are two main ways to run the app:

### Option 1: VS Code Launch Configuration

- Open the Run and Debug panel in VS Code (⌘⇧D / Ctrl+Shift+D)
- Click the play button ▶️
- Select "React: Designer" from the dropdown
- When prompted, enter your Courier API key, template ID, tenant ID, and JWT
- The dev server will start and automatically open in your browser

### Option 2: Command Line

From this directory:

1. Create a `.env` file with:
  ```
  VITE_COURIER_TEMPLATE_ID=your_template_id
  VITE_COURIER_TENANT_ID=your_tenant_id
  VITE_COURIER_JWT=your_jwt_token
  ```
2. Run
  ```
  npm i
  ```
3. Run 
  ```
  npm run dev
  ```
4. Open http://localhost:5173 in your browser

## Documentation

For complete reference documentation, see the [Courier React Designer documentation](https://github.com/trycourier/courier-designer/tree/main/packages/react-designer).

