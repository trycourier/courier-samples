# Courier Web Inbox

![Screenshot](../../assets/inbox.png)

## Run the app

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

