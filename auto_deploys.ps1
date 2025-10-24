# ==============================
# ⚙️ TORQUE EMPIRE AUTO WATCH & DEPLOY (FIXED VERSION)
# ==============================

$projectPath = "C:\torqueempire\torque-empire-atlas-backend"
$serviceName = "torque-empire-atlas-backend"
$domain = "https://app.torqueempire.co.za/health"

Set-Location $projectPath
Write-Host "🚀 Torque Empire Continuous Deployment Watcher Started..." -ForegroundColor Cyan
Write-Host "📁 Monitoring: $projectPath" -ForegroundColor Yellow
Write-Host "---------------------------------------------"

function Deploy-TorqueEmpire {
    Write-Host "`n🔄 Change detected — syncing & redeploying..." -ForegroundColor Cyan

    # 🧹 Clean up .txt duplicates
    Write-Host "🧹 Cleaning up .txt duplicates..."
    Get-ChildItem -Path $projectPath -Recurse -Include *.txt | ForEach-Object {
        $original = $_.FullName -replace '\.txt$', ''
        if (Test-Path $original) {
            Write-Host "✔ Keeping $original and removing $($_.Name)" -ForegroundColor Yellow
            Remove-Item $_.FullName -Force
        }
    }

    # 🔁 Git commit/push (optional)
    if (Test-Path "$projectPath\.git") {
        git add .
        git commit -m "⚡ Auto-sync $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        git push origin main
        Write-Host "✅ Code pushed to Git repository."
    }
    else {
        Write-Host "⚠️ No Git repo detected — skipping push."
    }

    # 🚄 Deploy to Railway
    Write-Host "🚄 Deploying to Railway..."
    railway up --service $serviceName --build

    # 🔍 Healthcheck
    Write-Host "🔍 Checking deployment health..."
    Start-Sleep -Seconds 15

    try {
        $response = Invoke-WebRequest -Uri $domain -UseBasicParsing -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ Healthcheck passed — Torque Empire backend is LIVE!" -ForegroundColor Green
        }
        else {
            Write-Host "⚠️ Healthcheck returned status code $($response.StatusCode)" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "❌ Healthcheck failed: $($_.Exception.Message)" -ForegroundColor Red
    }

    # 📜 Stream logs
    Write-Host "📜 Streaming recent logs..."
    railway logs --service $serviceName --tail 25
    Write-Host "🎯 Auto-deploy cycle complete — watching for more changes..." -ForegroundColor Cyan
}

# 👁️ Watch for file changes
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $projectPath
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

# 🪄 File change handler
Register-ObjectEvent $watcher Changed -Action {
    $ext = [System.IO.Path]::GetExtension($Event.SourceEventArgs.FullPath)
    if ($ext -in @(".R", ".py", ".json", ".Dockerfile", ".conf")) {
        Deploy-TorqueEmpire
    }
}

# 🕓 Keep script alive
while ($true) {
    Start-Sleep -Seconds 2
}