# Courier React Inbox

A minimal Vite + React + TypeScript application that displays the Courier Inbox component as a full-page application.

## Setup

1. Install dependencies:
   ```bash
   npm install
   ```

2. Ensure your `.env` file in the project root (`courier-samples/.env`) contains:
   ```
   VITE_USER_ID=your_user_id
   VITE_JWT=your_jwt_token
   ```

## Running

### Option 1: VS Code Launch Configuration
1. Open the Run and Debug panel (Cmd+Shift+D / Ctrl+Shift+D)
2. Select "React Inbox: Vite Dev Server" from the dropdown
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
