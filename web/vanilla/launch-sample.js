#!/usr/bin/env node

// Simple server that injects environment variables into HTML files
const http = require('http');
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const BASE_PORT = 8000;
const SAMPLE_DIR = process.argv[2] || process.cwd();

// Read .env file if it exists
function loadEnv() {
  const envFile = path.join(SAMPLE_DIR, '.env');
  const env = {};
  
  if (fs.existsSync(envFile)) {
    const content = fs.readFileSync(envFile, 'utf8');
    content.split('\n').forEach(line => {
      const match = line.match(/^([^=]+)=(.*)$/);
      if (match) {
        const key = match[1].trim();
        const value = match[2].trim().replace(/^["']|["']$/g, '');
        env[key] = value;
      }
    });
  }
  
  return env;
}

const env = loadEnv();
// Check both COURIER_ and VITE_COURIER_ prefixed versions
const userId = env.COURIER_USER_ID || env.VITE_COURIER_USER_ID || '';
const jwt = env.COURIER_JWT || env.VITE_COURIER_JWT || '';

const server = http.createServer((req, res) => {
  let filePath = path.join(SAMPLE_DIR, req.url === '/' ? 'index.html' : req.url);
  
  // Security: ensure file is within sample directory
  if (!filePath.startsWith(SAMPLE_DIR)) {
    res.writeHead(403);
    res.end('Forbidden');
    return;
  }
  
  // Default to index.html if file doesn't exist
  if (!fs.existsSync(filePath) || !fs.statSync(filePath).isFile()) {
    filePath = path.join(SAMPLE_DIR, 'index.html');
  }
  
  fs.readFile(filePath, 'utf8', (err, content) => {
    if (err) {
      res.writeHead(404);
      res.end('Not Found');
      return;
    }
    
    // If it's an HTML file, inject the environment variables
    if (path.extname(filePath) === '.html') {
      // Inject script tag before closing </body> tag
      const injectionScript = `
    <script>
      window.COURIER_USER_ID = ${JSON.stringify(userId)};
      window.COURIER_JWT = ${JSON.stringify(jwt)};
    </script>
`;
      content = content.replace('</body>', injectionScript + '</body>');
    }
    
    // Set appropriate content type
    const ext = path.extname(filePath);
    const contentTypes = {
      '.html': 'text/html',
      '.js': 'application/javascript',
      '.css': 'text/css',
      '.svg': 'image/svg+xml',
    };
    
    res.writeHead(200, { 'Content-Type': contentTypes[ext] || 'text/plain' });
    res.end(content);
  });
});

function findAvailablePort(startPort, callback) {
  const server = http.createServer();
  
  server.listen(startPort, () => {
    const port = server.address().port;
    server.close(() => {
      callback(null, port);
    });
  });
  
  server.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
      findAvailablePort(startPort + 1, callback);
    } else {
      callback(err, null);
    }
  });
}

findAvailablePort(BASE_PORT, (err, port) => {
  if (err) {
    console.error('Failed to find available port:', err);
    process.exit(1);
  }
  
  server.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
      console.error(`Port ${port} is already in use. This shouldn't happen.`);
    } else {
      console.error('Server error:', err);
    }
    process.exit(1);
  });
  
  server.listen(port, () => {
    console.log(`\n🚀 Server running at http://localhost:${port}`);
    console.log(`📁 Serving: ${SAMPLE_DIR}`);
    if (userId && jwt) {
      console.log(`✅ Environment variables loaded`);
    } else {
      console.log(`⚠️  No environment variables found. Set COURIER_USER_ID and COURIER_JWT in .env file`);
    }
    console.log(`\nPress Ctrl+C to stop\n`);
    
    try {
      const platform = process.platform;
      if (platform === 'darwin') {
        execSync(`open http://localhost:${port}`);
      } else if (platform === 'win32') {
        execSync(`start http://localhost:${port}`);
      } else {
        execSync(`xdg-open http://localhost:${port}`);
      }
    } catch (e) {
      // Ignore errors opening browser
    }
  });
});

