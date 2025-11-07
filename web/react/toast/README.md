# Courier React Toast

A minimal Vite + React + TypeScript application that displays the Courier Toast component for in-app notifications.

## Setup

1. Install dependencies:
   ```bash
   npm install
   ```

2. Ensure your `.env` file in the project root (`courier-samples/.env`) contains:
   ```
   VITE_COURIER_USER_ID=your_user_id
   VITE_COURIER_JWT=your_jwt_token
   ```

## Running

### Option 1: VS Code Launch Configuration
1. Open the Run and Debug panel (Cmd+Shift+D / Ctrl+Shift+D)
2. Select "React Toast: Vite Dev Server" from the dropdown
3. Click the play button or press F5
4. The dev server will start on port 5173 and automatically open in your browser

### Option 2: Command Line
```bash
npm run dev
```

The application will be available at `http://localhost:5173`

## Build

To create a production build:
```bash
npm run build
```

The built files will be in the `dist` directory.

## Features

The Courier Toast component displays short-lived notifications that:
- Sync with your Courier Inbox messages
- Can be auto-dismissed with configurable timeout
- Support action buttons
- Are fully customizable with themes

For more information, see the [Courier Toast Web Components documentation](https://www.courier.com/docs/sdk-libraries/courier-ui-toast-web).
