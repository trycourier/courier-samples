# Courier React Inbox Popup Menu

A minimal Vite + React + TypeScript application that displays the Courier Inbox Popup Menu component.

## Setup

1. Install dependencies:
   ```bash
   npm install
   ```

2. Configure environment variables. When using the VS Code launch configuration, you'll be prompted to enter your Courier API key, user ID, and JWT. Alternatively, create a `.env` file in this directory (`web/react/popup-menu/.env`) with:
   ```
   VITE_COURIER_USER_ID=your_user_id
   VITE_COURIER_JWT=your_jwt_token
   ```

## Running

### Option 1: VS Code Debug Play Button

1. Open the Run and Debug panel (⌘⇧D / Ctrl+Shift+D)
2. Select **"React: Popup Menu"** from the dropdown
3. Click the play button ▶️ or press F5
4. When prompted, enter your Courier API key, user ID, and JWT
5. The dev server will start and automatically open in your browser

### Option 2: npm

1. Navigate to this directory:
   ```bash
   cd web/react/popup-menu
   ```

2. Start the dev server:
   ```bash
   npm run dev
   ```

3. Open `http://localhost:5173` in your browser

## Build

Create a production build:
```bash
npm run build
```

Built files will be in the `dist` directory.

## Documentation

For complete reference documentation, see the [Courier React documentation](https://www.courier.com/docs/sdk-libraries/courier-react-web).
