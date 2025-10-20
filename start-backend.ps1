# start-backend.ps1
# Activates virtual environment and starts the backend server

Write-Host "Activating virtual environment..."
.\venv\Scripts\activate

Write-Host "Installing dependencies..."
pip install -r requirements.txt

Write-Host "Starting Uvicorn server..."
uvicorn main:app --reload