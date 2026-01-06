# Courier Web Inbox Popup Menu

![Screenshot](../../../assets/popup-menu.png)

## Run the app

There are two main ways to run the app:

### Option 1: VS Code Launch Configuration

- Open the Run and Debug panel in VS Code (⌘⇧D / Ctrl+Shift+D)
- Click the play button ▶️
- Select "Vanilla: Popup Menu" from the dropdown
- When prompted, enter your Courier API key and user ID
- The JWT token will be automatically generated (or regenerated if expired)
- The server will start and automatically open in your browser

### Demo

![Demo: Starting a sample app using the VS Code Launch Configuration](../../../assets/launcher-video.gif)

### Option 2: Command Line

From this directory:

1. Create a `.env` file or set environment variables:
   ```
   COURIER_USER_ID=your_user_id
   COURIER_JWT=your_jwt_token
   ```

2. Serve the HTML file using a local server. You can use any of these options:

   **Option 1: Using Python**
   ```bash
   python3 -m http.server 8000
   ```
   Then open http://localhost:8000 in your browser

   **Option 2: Using Node.js (npx)**
   ```bash
   npx serve .
   ```

   **Option 3: Using VS Code**
   - Install the "Live Server" extension
   - Right-click on `index.html` and select "Open with Live Server"

3. Set the environment variables in your browser console before loading:
   ```javascript
   window.COURIER_USER_ID = 'your_user_id';
   window.COURIER_JWT = 'your_jwt_token';
   ```
   Then refresh the page.

## Documentation

For complete reference documentation, see the [Courier Inbox Web Components documentation](https://www.courier.com/docs/sdk-libraries/courier-ui-inbox-web).

