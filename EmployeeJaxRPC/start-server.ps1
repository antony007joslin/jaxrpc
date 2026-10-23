# Start Liberty Server Script
# This script starts the WebSphere Liberty server

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting Liberty Server" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$serverPath = "C:\liberty\openliberty-jakartaee10-26.0.0.3\wlp\bin"
$serverName = "employeejaxrpc"

# Check if server directory exists
if (-not (Test-Path $serverPath)) {
    Write-Host "[ERROR] Server path not found: $serverPath" -ForegroundColor Red
    Write-Host "Please verify the Liberty installation path" -ForegroundColor Yellow
    exit 1
}

Write-Host "Server Path: $serverPath" -ForegroundColor Gray
Write-Host "Server Name: $serverName" -ForegroundColor Gray
Write-Host ""

# Change to server directory
Set-Location $serverPath

Write-Host "Starting server in foreground mode..." -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""
Write-Host "Once started, you can access:" -ForegroundColor Cyan
Write-Host "  - Server: http://localhost:9080" -ForegroundColor White
Write-Host "  - Services: http://localhost:9080/EmployeeJaxRPC/services" -ForegroundColor White
Write-Host "  - WSDL: http://localhost:9080/EmployeeJaxRPC/services/DepartmentService?wsdl" -ForegroundColor White
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Start server
.\server.bat run $serverName

# Made with Bob
