# Courier Samples

A collection of sample applications and scripts demonstrating how to integrate Courier's notification platform across web, mobile, and server environments.

## Quick Start

The easiest way to run any sample is using VS Code's **Launch Configuration** feature:

1. Open the Run and Debug panel (⌘⇧D / Ctrl+Shift+D)
2. Select the sample you want to run from the dropdown
3. Click the play button ▶️ or press F5
4. Follow any prompts to enter your Courier API credentials

### Demo

![Demo: Starting a sample app using the VS Code Launch Configuration](assets/launcher-video.gif)

## Prerequisites

Before running examples, ensure you have the required tools installed for your chosen language(s).

### Quick Check

Run the prerequisites checker to see what's installed:

```bash
bash scripts/check-prerequisites.sh
```

This script will verify:
- ✅ Required tools (Ruby, Python, Node.js, etc.)
- ⚠️ Optional tools (Go, PHP, Kotlin, C#)
- 🔧 Configuration (JAVA_HOME for Java/Kotlin)

### Language-Specific Requirements

Each language has its own requirements. See the README in each language directory for details:

- **[Ruby](./server/ruby/README.md)** - Ruby 2.6+, Bundler
- **[Python](./server/python/README.md)** - Python 3.7+, pip
- **[Node.js](./server/node/README.md)** - Node.js 14.0+, npm
- **[Java](./server/java/README.md)** - Java 11+, Maven
- **[Kotlin](./server/kotlin/README.md)** - Kotlin, Java 11+ (JAVA_HOME must be set)
- **[C#](./server/csharp/README.md)** - .NET SDK 10.0+
- **[Go](./server/go/README.md)** - Go 1.18+
- **[PHP](./server/php/README.md)** - PHP 7.4+, Composer

## Environment Variables Setup

Most samples require environment variables to be configured. You have two options:

**Option A: Using the interactive script (Recommended)**

The launch configurations will automatically prompt you for required variables using `scripts/set-env.sh`. You can also run it manually:

```bash
# From the project root, specify the directory and variables you need
bash scripts/set-env.sh --dir server/curl api_key generate_jwt_user_id
```

The script will prompt you for each variable interactively. If `.env.example` exists in the target directory, it will be used as a starting point.

**Option B: Copy from .env.example and edit manually**

1. Navigate to the sample directory (e.g., `server/curl/` or `server/python/`)
2. Copy the example file:
   ```bash
   cp .env.example .env
   ```
3. Edit `.env` with your actual Courier API credentials and values

**Note:** The `.env` file is gitignored and should never be committed to version control. Each sample directory may have its own `.env` file, or they may share one (e.g., `server/curl/.env` is shared by both curl and Python scripts).

## Sample Applications

### Web

#### React
- **[Inbox](./web/react/inbox/)** - Full-page notification center
- **[Toast](./web/react/toast/)** - Toast notifications
- **[Popup Menu](./web/react/popup-menu/)** - Inbox popup menu
- **[Designer](./web/react/designer/)** - Visual template editor

#### Vanilla JavaScript
- **[Inbox](./web/vanilla/inbox/)** - Full-page notification center
- **[Toast](./web/vanilla/toast/)** - Toast notifications
- **[Popup Menu](./web/vanilla/popup-menu/)** - Inbox popup menu

### Mobile

- **[Android](./mobile/android/)** (Coming Soon 🔜)
- **[iOS](./mobile/ios/)** (Coming Soon 🔜)
- **[Flutter](./mobile/flutter/)** (Coming Soon 🔜)
- **[React Native](./mobile/react-native/)** (Coming Soon 🔜)
- **[Expo](./mobile/expo/)** (Coming Soon 🔜)

### Server

- **[cURL Scripts](./server/curl/)**
- **[Node.js](./server/node/)**
- **[Python](./server/python/)**
- **[Java](./server/java/)**
- **[Kotlin](./server/kotlin/)**
- **[Go](./server/go/)**
- **[C#](./server/csharp/)**
- **[PHP](./server/php/)**
- **[Ruby](./server/ruby/)**

## Documentation

For complete documentation, see:
- [Courier API Documentation](https://www.courier.com/docs)

