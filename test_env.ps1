Write-Host "🔍 Checking Torque Empire Atlas environment setup..." -ForegroundColor Cyan
Write-Host "---------------------------------------------------"

# Step 1: Verify .env file
$envPath = ".\.env"
if (Test-Path $envPath) {
    Write-Host "✅ .env file found at: $envPath" -ForegroundColor Green
} else {
    Write-Host "❌ .env file NOT found in this folder!" -ForegroundColor Red
    Write-Host "   Please create one with the following line:" -ForegroundColor Yellow
    Write-Host "   OPENAI_API_KEY=sk-proj-yourkeyhere"
    exit
}

# Step 2: Check for key line
$keyLine = Get-Content $envPath | Select-String "OPENAI_API_KEY"
if ($keyLine) {
    Write-Host "✅ OPENAI_API_KEY line found in .env file" -ForegroundColor Green
} else {
    Write-Host "❌ OPENAI_API_KEY not found in .env file!" -ForegroundColor Red
    exit
}

# Step 3: Verify Python can load it
Write-Host "`n🐍 Verifying Python environment variable..." -ForegroundColor Cyan

# Use literal string (no PowerShell parsing inside)
$pythonCode = @'
from dotenv import load_dotenv
import os
load_dotenv()
key = os.getenv("OPENAI_API_KEY")
print("OPENAI_API_KEY:", key if key else "NOT FOUND")
'@

# Execute it safely
$pythonOutput = python -c $pythonCode

if ($pythonOutput -match "sk-") {
    Write-Host "✅ Python successfully detected your OpenAI key!" -ForegroundColor Green
    Write-Host $pythonOutput -ForegroundColor Gray
} else {
    Write-Host "❌ Python could NOT detect your OpenAI key." -ForegroundColor Red
    Write-Host "   Ensure you're in the correct virtual environment (venv activated)." -ForegroundColor Yellow
    exit
}

Write-Host "`n🏁 Environment check complete!" -ForegroundColor Cyan

# Step 4: Ask user to start backend
$runServer = Read-Host "🚀 Launch backend server now? (y/n)"
if ($runServer -eq "y") {
    Write-Host "`nStarting Uvicorn server..." -ForegroundColor Green
    Start-Process "cmd" "/k uvicorn main:app --reload"
    Start-Process "http://127.0.0.1:8000"
} else {
    Write-Host "❎ Server launch cancelled." -ForegroundColor Yellow
}
