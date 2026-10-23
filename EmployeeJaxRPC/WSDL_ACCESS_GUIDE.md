# WSDL Access Guide

## How to Access WSDL Files via HTTP

Once the Liberty server is running, you can access the WSDL files directly from your browser or any HTTP client.

## WSDL URLs

### Format
```
http://localhost:9080/EmployeeJaxRPC/services/{ServiceName}?wsdl
```

### All Service WSDLs

| Service | WSDL URL |
|---------|----------|
| **Department Service** | http://localhost:9080/EmployeeJaxRPC/services/DepartmentService?wsdl |
| **Employee Service** | http://localhost:9080/EmployeeJaxRPC/services/EmployeeService?wsdl |
| **Employee Query Service** | http://localhost:9080/EmployeeJaxRPC/services/EmployeeQueryService?wsdl |
| **Auth Service** | http://localhost:9080/EmployeeJaxRPC/services/AuthService?wsdl |

## Access Methods

### Method 1: Web Browser (Easiest)

Simply open your browser and navigate to any of the URLs above. For example:

```
http://localhost:9080/EmployeeJaxRPC/services/DepartmentService?wsdl
```

The WSDL XML will be displayed in your browser.

### Method 2: PowerShell

```powershell
# Download WSDL to view
Invoke-WebRequest -Uri "http://localhost:9080/EmployeeJaxRPC/services/DepartmentService?wsdl" -OutFile "DepartmentService-runtime.wsdl"

# Or just view in console
(Invoke-WebRequest -Uri "http://localhost:9080/EmployeeJaxRPC/services/DepartmentService?wsdl").Content
```

### Method 3: curl

```bash
curl http://localhost:9080/EmployeeJaxRPC/services/DepartmentService?wsdl
```

### Method 4: wget

```bash
wget http://localhost:9080/EmployeeJaxRPC/services/DepartmentService?wsdl -O DepartmentService-runtime.wsdl
```

## Quick Test Script

Save this as `test-wsdl-access.ps1`:

```powershell
Write-Host "Testing WSDL Access..." -ForegroundColor Cyan
Write-Host ""

$services = @(
    @{Name="Department Service"; URL="http://localhost:9080/EmployeeJaxRPC/services/DepartmentService?wsdl"},
    @{Name="Employee Service"; URL="http://localhost:9080/EmployeeJaxRPC/services/EmployeeService?wsdl"},
    @{Name="Employee Query Service"; URL="http://localhost:9080/EmployeeJaxRPC/services/EmployeeQueryService?wsdl"},
    @{Name="Auth Service"; URL="http://localhost:9080/EmployeeJaxRPC/services/AuthService?wsdl"}
)

foreach ($service in $services) {
    Write-Host "Testing: $($service.Name)" -ForegroundColor Yellow
    Write-Host "URL: $($service.URL)" -ForegroundColor Gray
    
    try {
        $response = Invoke-WebRequest -Uri $service.URL -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            Write-Host "✓ WSDL accessible" -ForegroundColor Green
            $wsdlContent = $response.Content
            if ($wsdlContent -match "<definitions") {
                Write-Host "✓ Valid WSDL document" -ForegroundColor Green
            }
        }
    } catch {
        Write-Host "✗ Failed to access WSDL" -ForegroundColor Red
        Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""
}
```

## Service List Page

Apache Axis also provides a service list page at:

```
http://localhost:9080/EmployeeJaxRPC/services
```

This page shows all deployed services with links to their WSDLs.

## Prerequisites

1. **Liberty Server Must Be Running**
   ```powershell
   cd C:\liberty\openliberty-jakartaee10-26.0.0.3\wlp\bin
   .\server.bat run employeejaxrpc
   ```

2. **Application Must Be Deployed**
   - WAR file should be in: `C:\liberty\openliberty-jakartaee10-26.0.0.3\wlp\usr\servers\employeejaxrpc\apps\`
   - Check server logs for successful deployment

3. **Port 9080 Must Be Available**
   - Default HTTP port is 9080
   - Check server.xml for configured port

## Troubleshooting

### Issue: Cannot Access WSDL (404 Error)

**Possible Causes:**
1. Server not running
2. Application not deployed
3. Wrong URL or service name
4. Port conflict

**Solutions:**

1. **Check if server is running:**
   ```powershell
   # Test server root
   Invoke-WebRequest -Uri "http://localhost:9080"
   ```

2. **Check application context:**
   ```powershell
   # Test application root
   Invoke-WebRequest -Uri "http://localhost:9080/EmployeeJaxRPC"
   ```

3. **Check services list:**
   ```
   http://localhost:9080/EmployeeJaxRPC/services
   ```

4. **Check server logs:**
   ```
   C:\liberty\openliberty-jakartaee10-26.0.0.3\wlp\usr\servers\employeejaxrpc\logs\messages.log
   ```

### Issue: WSDL Shows But Service Doesn't Work

**Check:**
1. Verify servlet initialization in logs
2. Check for NoClassDefFoundError (javax vs jakarta namespace issue)
3. Ensure server.xml uses servlet-4.0 (not servlet-6.0)

## Using WSDL in Client Applications

### Java Client (JAX-RPC)
```java
URL wsdlURL = new URL("http://localhost:9080/EmployeeJaxRPC/services/DepartmentService?wsdl");
DepartmentService service = new DepartmentServiceLocator();
DepartmentPortType port = service.getDepartmentPort();
```

### .NET Client
```csharp
// Add Service Reference in Visual Studio
// WSDL URL: http://localhost:9080/EmployeeJaxRPC/services/DepartmentService?wsdl
```

### SoapUI
1. File → New SOAP Project
2. Enter WSDL URL: `http://localhost:9080/EmployeeJaxRPC/services/DepartmentService?wsdl`
3. Click OK

### Postman
1. New Request → Body → raw → XML
2. Use the WSDL to understand request structure
3. Send POST to: `http://localhost:9080/EmployeeJaxRPC/services/DepartmentService`

## Example: Department Service WSDL

When you access:
```
http://localhost:9080/EmployeeJaxRPC/services/DepartmentService?wsdl
```

You'll see the WSDL definition including:
- Service operations (GetDepartments)
- Message formats (request/response)
- Data types (DepartmentType)
- Binding information (SOAP 1.1)
- Service endpoint URL

The WSDL is dynamically generated by Apache Axis based on the deployed service.

---

**Made with Bob**