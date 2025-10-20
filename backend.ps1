# ==============================
# Torque Empire Atlas Backend Starter
# ==============================

Write-Host "🚀 Starting Torque Empire Atlas Backend..." -ForegroundColor Cyan

# Navigate to project directory
Set-Location "C:\Users\torqu\Desktop\torque-empire-atlas-backend"

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Yellow
& .\venv\Scripts\activate

# Upgrade pip and dependencies
Write-Host "Checking dependencies..." -ForegroundColor Yellow
pip install --upgrade pip >$null 2>&1
pip install -r requirements.txt >$null 2>&1

# Start the backend server
Write-Host "✅ Backend environment ready!" -ForegroundColor Green
Write-Host "🌐 Launching server at http://127.0.0.1:8000 ..." -ForegroundColor Green
python -m uvicorn main:app --reload