# EmployeeJaxRPC - Runtime Setup Guide

## Quick Start Options

You have several options to run the EmployeeJaxRPC.war file. Here are the easiest and most recommended approaches:

---

## Option 1: Apache Tomcat (Easiest & Fastest) ⭐ RECOMMENDED

### Why Tomcat?
- ✅ Lightweight and fast startup
- ✅ Easy to install and configure
- ✅ Perfect for development and testing
- ✅ No complex setup required

### Installation Steps

#### Windows:
1. **Download Tomcat 9**
   ```
   https://tomcat.apache.org/download-90.cgi
   ```
   - Download: "32-bit/64-bit Windows Service Installer" (.exe)
   - Or download: "64-bit Windows zip" (portable)

2. **Install Tomcat**
   - Run installer (if using .exe)
   - Or extract ZIP to: `C:\apache-tomcat-9.0.xx`

3. **Deploy WAR File**
   ```powershell
   # Copy WAR to Tomcat webapps directory
   copy dist\EmployeeJaxRPC.war C:\apache-tomcat-9.0.xx\webapps\
   ```

4. **Start Tomcat**
   ```powershell
   # If installed as service:
   net start Tomcat9
   
   # Or run from command line:
   cd C:\apache-tomcat-9.0.xx\bin
   .\startup.bat
   ```

5. **Access Services**
   ```
   http://localhost:8080/EmployeeJaxRPC/services
   ```

6. **View Logs**
   ```
   C:\apache-tomcat-9.0.xx\logs\catalina.out
   ```

#### Linux/Mac:
```bash
# Download and extract
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.xx/bin/apache-tomcat-9.0.xx.tar.gz
tar -xzf apache-tomcat-9.0.xx.tar.gz
cd apache-tomcat-9.0.xx

# Deploy WAR
cp /path/to/EmployeeJaxRPC.war webapps/

# Start Tomcat
./bin/startup.sh

# Access services
http://localhost:8080/EmployeeJaxRPC/services
```

---

## Option 2: IBM WebSphere Liberty (Enterprise Option)

### Why Liberty?
- ✅ Lightweight IBM runtime
- ✅ Fast startup (seconds)
- ✅ Enterprise features
- ✅ Good for IBM environments

### Installation Steps

#### 1. Download Liberty
```
https://www.ibm.com/support/pages/websphere-liberty-developers
```
Or use IBM Installation Manager

#### 2. Extract Liberty
```powershell
# Windows
Expand-Archive wlp-*.zip -DestinationPath C:\wlp

# Linux/Mac
unzip wlp-*.zip -d /opt/
```

#### 3. Create Server
```bash
cd C:\wlp\bin   # Windows
cd /opt/wlp/bin # Linux/Mac

# Create a new server
./server create employeeServer
```

#### 4. Configure server.xml
Create/edit: `C:\wlp\usr\servers\employeeServer\server.xml`

```xml
<server description="Employee JAX-RPC Server">
    <featureManager>
        <feature>servlet-4.0</feature>
        <feature>jsp-2.3</feature>
    </featureManager>
    
    <httpEndpoint id="defaultHttpEndpoint"
                  host="*"
                  httpPort="9080"
                  httpsPort="9443" />
    
    <application id="EmployeeJaxRPC" 
                 location="EmployeeJaxRPC.war" 
                 name="EmployeeJaxRPC" 
                 type="war">
        <classloader delegation="parentLast"/>
    </application>
    
    <logging consoleLogLevel="INFO" />
</server>
```

#### 5. Deploy WAR
```powershell
# Copy WAR to apps directory
copy dist\EmployeeJaxRPC.war C:\wlp\usr\servers\employeeServer\apps\
```

#### 6. Start Server
```bash
cd C:\wlp\bin
./server start employeeServer

# View logs in real-time
./server run employeeServer
```

#### 7. Access Services
```
http://localhost:9080/EmployeeJaxRPC/services
```

#### 8. Stop Server
```bash
./server stop employeeServer
```

---

## Option 3: Jetty (Alternative Lightweight Option)

### Installation Steps

#### 1. Download Jetty
```
https://www.eclipse.org/jetty/download.php
```

#### 2. Extract and Deploy
```bash
# Extract Jetty
unzip jetty-distribution-*.zip
cd jetty-distribution-*

# Deploy WAR
cp /path/to/EmployeeJaxRPC.war webapps/

# Start Jetty
java -jar start.jar

# Access services
http://localhost:8080/EmployeeJaxRPC/services
```

---

## Option 4: Docker Container (Modern Approach)

### Create Dockerfile
```dockerfile
FROM tomcat:9-jdk11

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file
COPY dist/EmployeeJaxRPC.war /usr/local/tomcat/webapps/

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
```

### Build and Run
```bash
# Build Docker image
docker build -t employee-jaxrpc:1.0 .

# Run container
docker run -d -p 8080:8080 --name employee-service employee-jaxrpc:1.0

# View logs
docker logs -f employee-service

# Access services
http://localhost:8080/EmployeeJaxRPC/services

# Stop container
docker stop employee-service
```

---

## Testing Your Deployment

### 1. Check Service List
Open browser:
```
http://localhost:8080/EmployeeJaxRPC/services
```
or
```
http://localhost:9080/EmployeeJaxRPC/services  (Liberty)
```

You should see:
- EmployeeService
- EmployeeQueryService
- DepartmentService
- AuthService

### 2. View WSDL
```
http://localhost:8080/EmployeeJaxRPC/services/EmployeeService?wsdl
```

### 3. Test with Sample Request

#### Using cURL:
```bash
curl -X POST http://localhost:8080/EmployeeJaxRPC/services/EmployeeService \
  -H "Content-Type: text/xml; charset=utf-8" \
  -H "SOAPAction: \"\"" \
  -d @samples/requests/CreateEmployee-Request.xml
```

#### Using PowerShell:
```powershell
$headers = @{
    "Content-Type" = "text/xml; charset=utf-8"
    "SOAPAction" = '""'
}

$body = Get-Content samples/requests/CreateEmployee-Request.xml -Raw

Invoke-WebRequest -Uri "http://localhost:8080/EmployeeJaxRPC/services/EmployeeService" `
    -Method POST `
    -Headers $headers `
    -Body $body
```

---

## Comparison Table

| Server | Startup Time | Memory | Ease of Use | Best For |
|--------|-------------|---------|-------------|----------|
| **Tomcat** | ~5 sec | ~100 MB | ⭐⭐⭐⭐⭐ | Development, Testing |
| **Liberty** | ~10 sec | ~150 MB | ⭐⭐⭐⭐ | Enterprise, IBM Env |
| **Jetty** | ~5 sec | ~80 MB | ⭐⭐⭐⭐ | Lightweight Apps |
| **Docker** | ~10 sec | ~200 MB | ⭐⭐⭐ | Cloud, Containers |

---

## Recommended Setup for Different Scenarios

### For Quick Testing (5 minutes):
```
1. Download Tomcat 9 (ZIP version)
2. Extract to C:\apache-tomcat-9.0.xx
3. Copy WAR to webapps folder
4. Run bin\startup.bat
5. Open http://localhost:8080/EmployeeJaxRPC/services
```

### For Development:
- Use **Tomcat** with IDE integration (Eclipse, IntelliJ)
- Enable hot deployment
- Use debug mode

### For IBM Environment:
- Use **WebSphere Liberty**
- Configure with server.xml
- Use Liberty Developer Tools

### For Production:
- Use **WebSphere Application Server** (Traditional)
- Or **Liberty** with proper configuration
- Enable security, monitoring, clustering

---

## Troubleshooting

### Port Already in Use
**Tomcat:**
```xml
<!-- Edit conf/server.xml -->
<Connector port="8081" protocol="HTTP/1.1" ... />
```

**Liberty:**
```xml
<!-- Edit server.xml -->
<httpEndpoint httpPort="9081" httpsPort="9444" />
```

### Services Not Showing
1. Check WAR deployed: Look in webapps folder
2. Check logs for errors
3. Verify Axis servlet is loaded
4. Check web.xml configuration

### WSDL Not Accessible
1. Verify application started successfully
2. Check context root: `/EmployeeJaxRPC`
3. Verify URL: `http://localhost:8080/EmployeeJaxRPC/services`
4. Check firewall settings

---

## Next Steps

1. **Choose your runtime** (Tomcat recommended for quick start)
2. **Deploy the WAR file**
3. **Verify services are accessible**
4. **Test with sample requests** from `samples/requests/`
5. **Review logs** for any issues
6. **Start developing your client application**

---

## Quick Command Reference

### Tomcat
```bash
# Start
bin/startup.bat         # Windows
bin/startup.sh          # Linux/Mac

# Stop
bin/shutdown.bat        # Windows
bin/shutdown.sh         # Linux/Mac

# Logs
tail -f logs/catalina.out
```

### Liberty
```bash
# Start
bin/server start employeeServer

# Stop
bin/server stop employeeServer

# View logs
bin/server run employeeServer

# Status
bin/server status employeeServer
```

---

**Need Help?** Check DEPLOYMENT_GUIDE.md for detailed deployment instructions for all supported servers.