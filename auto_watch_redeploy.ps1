# ============================
# 🚀 Torque Empire Auto-Watch & Redeploy Script
# ============================

# --- Settings ---
$projectPath  = "C:\torqueempire\torque-empire-atlas-backend"
$railwayCLI   = "C:\Users\user\AppData\Roaming\npm\railway.cmd"  # ✅ Real CLI path
$healthURL    = "https://app.torqueempire.co.za/health"
$checkInterval = 60   # seconds

# --- Header ---
Write-Host "`n=========================================" -ForegroundColor Cyan
Write-Host "🚀 Torque Empire Auto-Watch & Redeploy Script" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "[Monitoring Path]: $projectPath" -ForegroundColor Yellow
Write-Host "[Health Check Timer]: Every $checkInterval seconds" -ForegroundColor Yellow
Write-Host "[Press Ctrl + C to stop]" -ForegroundColor Yellow
Write-Host "----------------------------------------`n"

# --- Function: Deploy changes to Railway ---
function Deploy-TorqueEmpire {
    try {
        Write-Host "[CHANGE DETECTED] Redeploying..." -ForegroundColor Magenta
        Write-Host "[DEPLOY] Deploying changes to Railway..." -ForegroundColor Cyan
        & $railwayCLI up --service torque-empire-atlas-backend --yes
        Write-Host "[DEPLOY COMPLETE ✅] Redeployment finished.`n" -ForegroundColor Green
    } catch {
        Write-Host "[DEPLOY ERROR ❌] $($_.Exception.Message)" -ForegroundColor Red
    }
}

# --- Function: Health check for the app ---
function Check-Health {
    try {
        $response = Invoke-WebRequest -Uri $healthURL -TimeoutSec 10 -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Host "[HEALTH OK ✅] $((Get-Date).ToString('HH:mm:ss')) - Service is healthy." -ForegroundColor Green
        } else {
            Write-Host "[HEALTH FAIL ⚠️] $((Get-Date).ToString('HH:mm:ss')) - Service returned $($response.StatusCode)." -ForegroundColor Red
        }
    } catch {
        Write-Host "[HEALTH FAIL ❌] $((Get-Date).ToString('HH:mm:ss')) - Service unreachable." -ForegroundColor Red
    }
}

# --- File System Watcher: Monitors for changes ---
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $projectPath
$watcher.IncludeSubdirectories = $true
$watcher.Filter = "*.*"
$watcher.EnableRaisingEvents = $true

Register-ObjectEvent $watcher Changed -Action {
    $path = $Event.SourceEventArgs.FullPath
    Write-Host "`n[CHANGE DETECTED 🔄] $path" -ForegroundColor Yellow
    Deploy-TorqueEmpire
}

# --- Continuous Loop ---
while ($true) {
    Check-Health
    Start-Sleep -Seconds $checkInterval
}