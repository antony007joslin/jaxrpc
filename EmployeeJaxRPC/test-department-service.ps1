# Test Department Service
# This script tests the Department Service SOAP endpoint

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Department Service Test Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$serverPath = "C:\liberty\openliberty-jakartaee10-26.0.0.3\wlp\bin"
$serviceUrl = "http://localhost:9080/EmployeeJaxRPC/services/DepartmentService"
$requestFile = "samples/requests/GetDepartments-Request.xml"

# Check if server is running
Write-Host "Checking if Liberty server is running..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:9080" -Method GET -TimeoutSec 2 -ErrorAction Stop
    Write-Host "✓ Server is running" -ForegroundColor Green
} catch {
    Write-Host "✗ Server is not running" -ForegroundColor Red
    Write-Host ""
    Write-Host "To start the server, run:" -ForegroundColor Yellow
    Write-Host "  cd $serverPath" -ForegroundColor White
    Write-Host "  .\server.bat start employeejaxrpc" -ForegroundColor White
    Write-Host ""
    Write-Host "Or run it in the foreground:" -ForegroundColor Yellow
    Write-Host "  .\server.bat run employeejaxrpc" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "Testing Department Service..." -ForegroundColor Yellow
Write-Host "Service URL: $serviceUrl" -ForegroundColor Gray
Write-Host "Request File: $requestFile" -ForegroundColor Gray
Write-Host ""

# Read the SOAP request
if (-not (Test-Path $requestFile)) {
    Write-Host "✗ Request file not found: $requestFile" -ForegroundColor Red
    exit 1
}

$soapRequest = Get-Content $requestFile -Raw

# Send SOAP request
try {
    Write-Host "Sending SOAP request..." -ForegroundColor Yellow
    $response = Invoke-WebRequest -Uri $serviceUrl `
                                  -Method POST `
                                  -ContentType "text/xml; charset=utf-8" `
                                  -Headers @{"SOAPAction"=""} `
                                  -Body $soapRequest `
                                  -ErrorAction Stop
    
    Write-Host "✓ Request successful!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Response Status: $($response.StatusCode) $($response.StatusDescription)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Response Body:" -ForegroundColor Cyan
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    # Pretty print XML response
    $xmlResponse = [xml]$response.Content
    $stringWriter = New-Object System.IO.StringWriter
    $xmlWriter = New-Object System.Xml.XmlTextWriter($stringWriter)
    $xmlWriter.Formatting = "Indented"
    $xmlWriter.Indentation = 2
    $xmlResponse.WriteContentTo($xmlWriter)
    $xmlWriter.Flush()
    $stringWriter.Flush()
    Write-Host $stringWriter.ToString() -ForegroundColor White
    
    Write-Host "----------------------------------------" -ForegroundColor Gray
    Write-Host ""
    
    # Parse and display departments
    $ns = @{
        soap = "http://schemas.xmlsoap.org/soap/envelope/"
        v1 = "http://example.com/department/service/v1"
        dept = "http://example.com/department/v1"
    }
    
    $departments = Select-Xml -Xml $xmlResponse -XPath "//dept:DepartmentType" -Namespace $ns
    
    if ($departments) {
        Write-Host "Departments Found:" -ForegroundColor Green
        foreach ($dept in $departments) {
            $deptNode = $dept.Node
            $id = $deptNode.departmentId
            $name = $deptNode.departmentName
            $code = $deptNode.departmentCode
            Write-Host "  - ID: $id, Code: $code, Name: $name" -ForegroundColor White
        }
    } else {
        Write-Host "No departments found in response" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "✗ Request failed!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host ""
        Write-Host "Error Response:" -ForegroundColor Yellow
        Write-Host $responseBody -ForegroundColor Gray
    }
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Test completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

# Made with Bob
