# Initialize Courier C# SDK submodule if it doesn't exist
# PowerShell script for Windows

$ProjectRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$SDK_PATH = Join-Path $ProjectRoot "server\courier-csharp"

# Check if SDK directory exists and has content
if (-not (Test-Path $SDK_PATH) -or ((Get-ChildItem $SDK_PATH -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0)) {
    Write-Host "📦 Courier C# SDK submodule not found. Initializing..." -ForegroundColor Yellow
    
    Push-Location $ProjectRoot
    
    try {
        # Initialize and update submodules
        git submodule update --init --recursive server/courier-csharp
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Courier C# SDK initialized successfully" -ForegroundColor Green
        } else {
            Write-Host "⚠ Warning: Could not initialize submodule automatically." -ForegroundColor Yellow
            Write-Host "  Please run manually: git submodule update --init --recursive" -ForegroundColor Yellow
            exit 1
        }
    } finally {
        Pop-Location
    }
}

