# Courier Samples

A collection of sample applications and scripts demonstrating how to integrate Courier's notification platform across web, mobile, and server environments.

## Quick Start

The easiest way to run any sample is using VS Code's **Launch Configuration** feature:

1. Open the Run and Debug panel (⌘⇧D / Ctrl+Shift+D)
2. Select the sample you want to run from the dropdown
3. Click the play button ▶️ or press F5
4. Follow any prompts to enter your Courier API key and other required values

Available launch configurations include:
- **React: Inbox** - Full-page inbox component
- **React: Toast** - Toast notifications component
- **React: Popup Menu** - Inbox popup menu component
- **Curl: Generate JWT** - Generate a JWT token for authentication
- **Curl: Send Template to Email** - Send a template notification to an email
- **Curl: Send Template to User ID** - Send a template notification to a user ID

### Demo

![Demo: Starting a sample app using the VS Code Launch Configuration](assets/launcher-video.gif)

## Sample Applications

### Web (React)

- **[Inbox](./web/react/inbox/)** - Full-page notification center
- **[Toast](./web/react/toast/)** - Toast notifications
- **[Popup Menu](./web/react/popup-menu/)** - Inbox popup menu

Each React sample includes detailed setup and running instructions in its README.

### Mobile

> **Note:** Mobile examples are coming soon. The following platforms are supported:
> - **Android** - Inbox and Push notification samples
> - **iOS** - Inbox and Push notification samples
> - **Flutter** - Inbox and Push notification samples
> - **React Native** - Inbox and Push notification samples
> - **Expo** - Inbox and Push notification samples

### Server

- **[cURL Scripts](./server/curl/)** - Command-line examples for sending notifications and generating JWTs
- **[Node.js](./server/node/)** - Node.js server examples

## Documentation

For complete reference documentation, see:
- [Courier API Documentation](https://www.courier.com/docs/reference)

## Requirements

- Node.js (for React and Node.js samples)
- VS Code (recommended for launch configurations)
- Courier API key and account

Each sample directory contains its own README with specific setup instructions.

