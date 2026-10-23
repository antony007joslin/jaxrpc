# Quick Start Guide - EmployeeJaxRPC

This guide will help you get the EmployeeJaxRPC web services up and running quickly.

## Prerequisites Check

Before starting, ensure you have:

- [ ] Java JDK 1.8+ installed
- [ ] Apache ANT installed
- [ ] Application server (WebSphere, Liberty, or Tomcat)
- [ ] All required JAR files in `lib/` directory

## Step-by-Step Setup

### 1. Download Dependencies (5 minutes)

```bash
# Navigate to project directory
cd EmployeeJaxRPC

# Create lib directory if needed
mkdir -p lib

# Download Apache Axis 1.4 distribution
# Extract and copy JARs to lib/ directory
# See lib/DEPENDENCIES.md for complete list
```

**Quick Download Option:**
```bash
# Use wget or curl to download JARs from Maven Central
# See lib/DEPENDENCIES.md for direct download links
```

### 2. Verify Setup

```bash
# Check Java
java -version
# Should show: java version "1.8.0" or higher

# Check ANT
ant -version
# Should show: Apache Ant(TM) version 1.9.x or higher

# Check dependencies
ls -la lib/
# Should show 9 JAR files
```

### 3. Build the Project (2 minutes)

```bash
# Clean and build everything
ant all

# Expected output:
# [echo] Cleaning build artifacts...
# [echo] Generating EmployeeService artifacts...
# [echo] Compiling generated sources...
# [echo] Compiling implementation sources...
# [echo] Creating WAR file...
# BUILD SUCCESSFUL
```

### 4. Deploy to Application Server

#### Option A: WebSphere Liberty (Easiest)

```bash
# Copy WAR to Liberty dropins
cp dist/EmployeeJaxRPC.war $WLP_HOME/usr/servers/defaultServer/dropins/

# Start Liberty
$WLP_HOME/bin/server start defaultServer

# Check logs
tail -f $WLP_HOME/usr/servers/defaultServer/logs/messages.log
```

#### Option B: Apache Tomcat

```bash
# Copy WAR to Tomcat webapps
cp dist/EmployeeJaxRPC.war $CATALINA_HOME/webapps/

# Start Tomcat
$CATALINA_HOME/bin/startup.sh

# Check logs
tail -f $CATALINA_HOME/logs/catalina.out
```

#### Option C: WebSphere Application Server

```bash
# Use Admin Console
# Navigate to: Applications > New Application > New Enterprise Application
# Select: dist/EmployeeJaxRPC.war
# Follow wizard and start application
```

### 5. Verify Deployment (1 minute)

Open browser and check:

```
http://localhost:8080/EmployeeJaxRPC/services
```

You should see a list of available services:
- EmployeeService
- EmployeeQueryService
- DepartmentService
- AuthService

### 6. Test Services (5 minutes)

#### Test 1: Get Departments (No authentication required)

```bash
curl -X POST http://localhost:8080/EmployeeJaxRPC/services/DepartmentService \
  -H "Content-Type: text/xml" \
  -H "SOAPAction: http://example.com/department/service/v1/GetDepartments" \
  -d @samples/requests/GetDepartments-Request.xml
```

**Expected Response:**
```xml
<soapenv:Envelope>
  <soapenv:Body>
    <GetDepartmentsResponse>
      <departments>
        <deptId>1</deptId>
        <deptName>Engineering</deptName>
      </departments>
      <!-- More departments... -->
    </GetDepartmentsResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

#### Test 2: Login

```bash
curl -X POST http://localhost:8080/EmployeeJaxRPC/services/AuthService \
  -H "Content-Type: text/xml" \
  -H "SOAPAction: login" \
  -d @samples/requests/Login-Request.xml
```

**Expected Response:**
```xml
<soapenv:Envelope>
  <soapenv:Body>
    <LoginResponse>
      <status>
        <code>SUCCESS</code>
        <message>Authentication successful</message>
      </status>
      <token>TOKEN-admin-xxxxx</token>
    </LoginResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

#### Test 3: Create Employee

```bash
curl -X POST http://localhost:8080/EmployeeJaxRPC/services/EmployeeService \
  -H "Content-Type: text/xml" \
  -H "SOAPAction: CreateEmployee" \
  -d @samples/requests/CreateEmployee-Request.xml
```

**Expected Response:**
```xml
<soapenv:Envelope>
  <soapenv:Body>
    <CreateEmployeeResponse>
      <status>
        <code>SUCCESS</code>
        <message>Employee created successfully</message>
      </status>
      <empId>1001</empId>
    </CreateEmployeeResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

## Using SOAP UI

### 1. Install SOAP UI
Download from: https://www.soapui.org/downloads/soapui/

### 2. Create New SOAP Project
- File > New SOAP Project
- Project Name: EmployeeJaxRPC
- Initial WSDL: http://localhost:8080/EmployeeJaxRPC/services/EmployeeService?wsdl
- Click OK

### 3. Test Operations
- Expand EmployeeService > EmployeeBinding
- Double-click on any operation (e.g., CreateEmployee)
- Use sample request from `samples/requests/` directory
- Click green play button to execute

## Troubleshooting

### Problem: Build fails with "axis-wsdl2java not found"

**Solution:**
```bash
# Ensure all Axis JARs are in lib/ directory
ls lib/axis.jar lib/jaxrpc.jar lib/wsdl4j-1.5.1.jar
```

### Problem: Services not found after deployment

**Solution:**
```bash
# Check server-config.wsdd is in WEB-INF
# Verify WAR structure:
jar -tf dist/EmployeeJaxRPC.war | grep server-config.wsdd
# Should show: WEB-INF/server-config.wsdd
```

### Problem: ClassNotFoundException at runtime

**Solution:**
```bash
# Verify all JARs are in WAR
jar -tf dist/EmployeeJaxRPC.war | grep "WEB-INF/lib"
# Should list all required JARs
```

### Problem: SOAP Fault - Method not found

**Solution:**
- Check SOAPAction header matches WSDL
- Verify namespace in request matches WSDL
- Check server-config.wsdd operation mappings

## Next Steps

1. **View WSDLs:**
   - http://localhost:8080/EmployeeJaxRPC/services/EmployeeService?wsdl
   - http://localhost:8080/EmployeeJaxRPC/services/EmployeeQueryService?wsdl
   - http://localhost:8080/EmployeeJaxRPC/services/DepartmentService?wsdl
   - http://localhost:8080/EmployeeJaxRPC/services/AuthService?wsdl

2. **Review Sample Requests:**
   - Check `samples/requests/` directory
   - Modify for your test scenarios

3. **Check Logs:**
   - Application logs: `${server}/logs/employee-jaxrpc.log`
   - Server logs: Check your application server logs directory

4. **Customize:**
   - Modify service implementations in `src/main/java/`
   - Update business logic
   - Add database integration
   - Rebuild with `ant all`

## Production Checklist

Before deploying to production:

- [ ] Replace in-memory storage with database
- [ ] Implement proper authentication/authorization
- [ ] Enable HTTPS/TLS
- [ ] Configure production logging levels
- [ ] Set up monitoring and alerting
- [ ] Perform load testing
- [ ] Review security configurations
- [ ] Document API for consumers
- [ ] Set up backup and recovery procedures

## Support

For detailed information, see:
- **README.md** - Complete documentation
- **lib/DEPENDENCIES.md** - Dependency information
- **samples/** - Request/response examples

## Success!

If you've completed all steps successfully, you now have:
- ✅ A fully functional JAX-RPC SOAP web service
- ✅ Four operational services (Employee, Query, Department, Auth)
- ✅ Sample requests for testing
- ✅ Complete build and deployment automation

**Happy coding!** 🚀