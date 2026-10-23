# Test WSDL Access Script
# This script tests if all WSDL files are accessible via HTTP

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "WSDL Access Test Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if server is running first
Write-Host "Checking if Liberty server is running..." -ForegroundColor Yellow
try {
    $serverCheck = Invoke-WebRequest -Uri "http://localhost:9080" -Method GET -TimeoutSec 2 -ErrorAction Stop
    Write-Host "[OK] Server is running" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Server is not running" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please start the server first:" -ForegroundColor Yellow
    Write-Host "  cd C:\liberty\openliberty-jakartaee10-26.0.0.3\wlp\bin" -ForegroundColor White
    Write-Host "  .\server.bat run employeejaxrpc" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "Testing WSDL Access for All Services..." -ForegroundColor Cyan
Write-Host ""

# Define services to test
$services = @(
    @{
        Name = "Department Service"
        URL = "http://localhost:9080/EmployeeJaxRPC/services/DepartmentService?wsdl"
        Operation = "GetDepartments"
    },
    @{
        Name = "Employee Service"
        URL = "http://localhost:9080/EmployeeJaxRPC/services/EmployeeService?wsdl"
        Operation = "CreateEmployee, GetEmployee, UpdateEmployee, DeleteEmployee"
    },
    @{
        Name = "Employee Query Service"
        URL = "http://localhost:9080/EmployeeJaxRPC/services/EmployeeQueryService?wsdl"
        Operation = "SearchEmployee"
    },
    @{
        Name = "Auth Service"
        URL = "http://localhost:9080/EmployeeJaxRPC/services/AuthService?wsdl"
        Operation = "Login"
    }
)

$successCount = 0
$failCount = 0

foreach ($service in $services) {
    Write-Host "Testing: $($service.Name)" -ForegroundColor Yellow
    Write-Host "URL: $($service.URL)" -ForegroundColor Gray
    Write-Host "Operations: $($service.Operation)" -ForegroundColor Gray
    
    try {
        $response = Invoke-WebRequest -Uri $service.URL -TimeoutSec 5 -ErrorAction Stop
        
        if ($response.StatusCode -eq 200) {
            Write-Host "[OK] HTTP Status: 200 OK" -ForegroundColor Green
            
            $wsdlContent = $response.Content
            
            # Validate WSDL content
            if ($wsdlContent -match "definitions") {
                Write-Host "[OK] Valid WSDL document (contains definitions element)" -ForegroundColor Green
            } else {
                Write-Host "[WARN] Response does not look like a WSDL" -ForegroundColor Yellow
            }
            
            # Check for service name in WSDL
            if ($wsdlContent -match "service name") {
                Write-Host "[OK] Service definition found" -ForegroundColor Green
            }
            
            # Check for binding
            if ($wsdlContent -match "binding") {
                Write-Host "[OK] SOAP binding found" -ForegroundColor Green
            }
            
            # Display WSDL size
            $sizeKB = [math]::Round($wsdlContent.Length / 1024, 2)
            Write-Host "[OK] WSDL Size: $sizeKB KB" -ForegroundColor Green
            
            $successCount++
        }
    } catch {
        Write-Host "[FAIL] Failed to access WSDL" -ForegroundColor Red
        Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
        
        if ($_.Exception.Response) {
            $statusCode = $_.Exception.Response.StatusCode.value__
            Write-Host "  HTTP Status: $statusCode" -ForegroundColor Red
        }
        
        $failCount++
    }
    
    Write-Host ""
}

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Test Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Total Services: $($services.Count)" -ForegroundColor White
Write-Host "Successful: $successCount" -ForegroundColor Green
Write-Host "Failed: $failCount" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "Green" })
Write-Host ""

if ($successCount -eq $services.Count) {
    Write-Host "[SUCCESS] All WSDLs are accessible!" -ForegroundColor Green
    Write-Host ""
    Write-Host "You can now:" -ForegroundColor Cyan
    Write-Host "  1. Open WSDLs in browser" -ForegroundColor White
    Write-Host "  2. Import into SoapUI or Postman" -ForegroundColor White
    Write-Host "  3. Generate client code" -ForegroundColor White
    Write-Host "  4. Test services with SOAP requests" -ForegroundColor White
    Write-Host ""
    Write-Host "Service List Page:" -ForegroundColor Cyan
    Write-Host "  http://localhost:9080/EmployeeJaxRPC/services" -ForegroundColor White
} else {
    Write-Host "[WARN] Some WSDLs are not accessible" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Cyan
    Write-Host "  1. Check server logs for errors" -ForegroundColor White
    Write-Host "  2. Verify application deployment" -ForegroundColor White
    Write-Host "  3. Check servlet initialization" -ForegroundColor White
    Write-Host ""
    Write-Host "Server Logs:" -ForegroundColor Cyan
    Write-Host "  C:\liberty\openliberty-jakartaee10-26.0.0.3\wlp\usr\servers\employeejaxrpc\logs\messages.log" -ForegroundColor White
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

# Made with Bob
