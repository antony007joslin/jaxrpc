# Testing Guide - Employee JAX-RPC Services

This guide provides instructions for testing the SOAP web services.

## Prerequisites

1. **Liberty Server Running**: Ensure the Liberty server is started
2. **Application Deployed**: EmployeeJaxRPC.war must be deployed
3. **Java EE 8 Features**: Server must use servlet-4.0 (not servlet-6.0)

## Starting the Liberty Server

### Option 1: Start in Background
```powershell
cd C:\liberty\openliberty-jakartaee10-26.0.0.3\wlp\bin
.\server.bat start employeejaxrpc
```

### Option 2: Run in Foreground (Recommended for Testing)
```powershell
cd C:\liberty\openliberty-jakartaee10-26.0.0.3\wlp\bin
.\server.bat run employeejaxrpc
```

### Check Server Status
```powershell
.\server.bat status employeejaxrpc
```

### Stop Server
```powershell
.\server.bat stop employeejaxrpc
```

## Service Endpoints

All services are available at: `http://localhost:9080/EmployeeJaxRPC/services/`

| Service | Endpoint | WSDL |
|---------|----------|------|
| Employee Service | `/EmployeeService` | `?wsdl` |
| Employee Query | `/EmployeeQueryService` | `?wsdl` |
| Department Service | `/DepartmentService` | `?wsdl` |
| Auth Service | `/AuthService` | `?wsdl` |

## Testing Methods

### Method 1: Using PowerShell Test Script (Recommended)

```powershell
# Test Department Service
.\test-department-service.ps1
```

### Method 2: Using Invoke-WebRequest (PowerShell)

```powershell
# Read request file
$body = Get-Content "samples/requests/GetDepartments-Request.xml" -Raw

# Send SOAP request
$response = Invoke-WebRequest `
    -Uri "http://localhost:9080/EmployeeJaxRPC/services/DepartmentService" `
    -Method POST `
    -ContentType "text/xml; charset=utf-8" `
    -Headers @{"SOAPAction"=""} `
    -Body $body

# Display response
$response.Content
```

### Method 3: Using curl (if installed)

```bash
curl -X POST \
  http://localhost:9080/EmployeeJaxRPC/services/DepartmentService \
  -H "Content-Type: text/xml; charset=utf-8" \
  -H "SOAPAction: " \
  -d @samples/requests/GetDepartments-Request.xml
```

### Method 4: Using SoapUI

1. Create new SOAP project
2. Import WSDL: `http://localhost:9080/EmployeeJaxRPC/services/DepartmentService?wsdl`
3. Execute test requests

## Sample Requests

All sample requests are in the `samples/requests/` directory:

### 1. Department Service - Get Departments

**File**: `samples/requests/GetDepartments-Request.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                  xmlns:v1="http://example.com/department/service/v1">
    <soapenv:Header/>
    <soapenv:Body>
        <v1:GetDepartmentsRequest/>
    </soapenv:Body>
</soapenv:Envelope>
```

**Expected Response**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
    <soapenv:Body>
        <ns1:GetDepartmentsResponse xmlns:ns1="http://example.com/department/service/v1">
            <departments xmlns:ns2="http://example.com/department/v1">
                <ns2:departmentId>1</ns2:departmentId>
                <ns2:departmentCode>IT</ns2:departmentCode>
                <ns2:departmentName>Information Technology</ns2:departmentName>
            </departments>
            <departments xmlns:ns2="http://example.com/department/v1">
                <ns2:departmentId>2</ns2:departmentId>
                <ns2:departmentCode>HR</ns2:departmentCode>
                <ns2:departmentName>Human Resources</ns2:departmentName>
            </departments>
            <!-- More departments... -->
        </ns1:GetDepartmentsResponse>
    </soapenv:Body>
</soapenv:Envelope>
```

### 2. Auth Service - Login

**File**: `samples/requests/Login-Request.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                  xmlns:v1="http://example.com/auth/service/v1"
                  xmlns:hdr="http://example.com/header/v1">
    <soapenv:Header>
        <hdr:RequestHeader>
            <hdr:requestId>REQ-001</hdr:requestId>
            <hdr:timestamp>2024-01-15T10:30:00Z</hdr:timestamp>
            <hdr:source>TestClient</hdr:source>
        </hdr:RequestHeader>
    </soapenv:Header>
    <soapenv:Body>
        <v1:LoginRequest>
            <v1:username>admin</v1:username>
            <v1:password>admin123</v1:password>
        </v1:LoginRequest>
    </soapenv:Body>
</soapenv:Envelope>
```

### 3. Employee Service - Create Employee

**File**: `samples/requests/CreateEmployee-Request.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                  xmlns:v1="http://example.com/employee/service/v1"
                  xmlns:emp="http://example.com/employee/v1"
                  xmlns:hdr="http://example.com/header/v1">
    <soapenv:Header>
        <hdr:RequestHeader>
            <hdr:requestId>REQ-002</hdr:requestId>
            <hdr:timestamp>2024-01-15T10:35:00Z</hdr:timestamp>
            <hdr:source>TestClient</hdr:source>
        </hdr:RequestHeader>
    </soapenv:Header>
    <soapenv:Body>
        <v1:CreateEmployeeRequest>
            <v1:employee>
                <emp:firstName>John</emp:firstName>
                <emp:lastName>Doe</emp:lastName>
                <emp:email>john.doe@example.com</emp:email>
                <emp:departmentId>1</emp:departmentId>
                <emp:salary>75000.00</emp:salary>
                <emp:hireDate>2024-01-15</emp:hireDate>
            </v1:employee>
        </v1:CreateEmployeeRequest>
    </soapenv:Body>
</soapenv:Envelope>
```

### 4. Employee Query - Search Employee

**File**: `samples/requests/SearchEmployee-Request.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                  xmlns:v1="http://example.com/employee/service/v1">
    <soapenv:Header/>
    <soapenv:Body>
        <v1:SearchEmployeeRequest>
            <v1:firstName>John</v1:firstName>
            <v1:departmentId>1</v1:departmentId>
        </v1:SearchEmployeeRequest>
    </soapenv:Body>
</soapenv:Envelope>
```

### 5. Employee Service - Get Employee

**File**: `samples/requests/GetEmployee-Request.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                  xmlns:v1="http://example.com/employee/service/v1">
    <soapenv:Header/>
    <soapenv:Body>
        <v1:GetEmployeeRequest>
            <v1:employeeId>1</v1:employeeId>
        </v1:GetEmployeeRequest>
    </soapenv:Body>
</soapenv:Envelope>
```

## Troubleshooting

### Issue: NoClassDefFoundError: javax.servlet.http.HttpServlet

**Solution**: Ensure server.xml uses Java EE 8 features:
```xml
<featureManager>
    <feature>servlet-4.0</feature>
    <feature>jsp-2.3</feature>
</featureManager>
```

### Issue: Service Not Found (404)

**Checks**:
1. Verify server is running: `http://localhost:9080`
2. Check application deployed: Look for EmployeeJaxRPC.war in apps folder
3. Verify service URL: `http://localhost:9080/EmployeeJaxRPC/services/DepartmentService`
4. Check server logs: `C:\liberty\openliberty-jakartaee10-26.0.0.3\wlp\usr\servers\employeejaxrpc\logs\messages.log`

### Issue: SOAP Fault Response

**Common Causes**:
- Invalid XML format
- Missing required fields
- Wrong namespace
- Service implementation error

**Check**:
1. Validate XML against WSDL
2. Review server logs for stack traces
3. Verify request matches WSDL schema

## Viewing WSDLs

Access WSDL documents in browser:

- Department Service: http://localhost:9080/EmployeeJaxRPC/services/DepartmentService?wsdl
- Employee Service: http://localhost:9080/EmployeeJaxRPC/services/EmployeeService?wsdl
- Employee Query: http://localhost:9080/EmployeeJaxRPC/services/EmployeeQueryService?wsdl
- Auth Service: http://localhost:9080/EmployeeJaxRPC/services/AuthService?wsdl

## Monitoring

### Server Logs
```
C:\liberty\openliberty-jakartaee10-26.0.0.3\wlp\usr\servers\employeejaxrpc\logs\messages.log
```

### Application Logs
Check console output or messages.log for application-specific logging.

## Next Steps

1. Start the Liberty server
2. Run the test script: `.\test-department-service.ps1`
3. Verify successful response
4. Test other services using sample requests
5. Integrate with your client application

---

**Made with Bob**