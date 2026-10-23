# EmployeeJaxRPC - Deployment Guide

## Overview
This guide provides detailed instructions for deploying the EmployeeJaxRPC web application to various enterprise application servers.

## Build Artifacts

### Generated WAR File
- **Location**: `dist/EmployeeJaxRPC.war`
- **Size**: ~2-3 MB (includes all dependencies)
- **Format**: Standard Java EE WAR file

### WAR Contents
```
EmployeeJaxRPC.war
├── META-INF/
│   └── MANIFEST.MF
├── WEB-INF/
│   ├── web.xml                    # Servlet configuration
│   ├── server-config.wsdd         # Axis deployment descriptor
│   ├── jaxrpc-mapping.xml         # JAX-RPC type mappings
│   ├── classes/                   # Compiled Java classes
│   │   └── com/example/...        # All service classes
│   └── lib/                       # Required JAR dependencies
│       ├── axis.jar
│       ├── jaxrpc.jar
│       ├── saaj.jar
│       ├── wsdl4j-1.5.1.jar
│       ├── commons-discovery-0.2.jar
│       ├── commons-logging-1.0.4.jar
│       ├── log4j-1.2.17.jar
│       ├── activation.jar
│       └── mail.jar
└── WSDLs/                         # Original WSDL files
    ├── EmployeeService.wsdl
    ├── EmployeeQuery.wsdl
    ├── DepartmentService.wsdl
    └── AuthService.wsdl
```

## Deployment Targets

### 1. IBM WebSphere Application Server (Traditional)

#### Prerequisites
- WebSphere Application Server 7.0 or higher
- Java 8 or higher
- Administrative console access

#### Deployment Steps

1. **Access Admin Console**
   ```
   https://localhost:9043/ibm/console
   ```

2. **Install Application**
   - Navigate to: Applications → New Application → New Enterprise Application
   - Select: `dist/EmployeeJaxRPC.war`
   - Click: Next through the wizard
   - Context Root: `/EmployeeJaxRPC`
   - Click: Finish

3. **Configure Application**
   - Navigate to: Applications → Application Types → WebSphere enterprise applications
   - Select: EmployeeJaxRPC
   - Click: Class loading and update detection
   - Set: Classes loaded with local class loader first (parent last)
   - Click: Apply and Save

4. **Start Application**
   - Select: EmployeeJaxRPC
   - Click: Start

5. **Verify Deployment**
   ```
   http://localhost:9080/EmployeeJaxRPC/services
   ```

#### WebSphere-Specific Configuration

**server.xml** (if needed):
```xml
<application id="EmployeeJaxRPC" 
             location="EmployeeJaxRPC.war" 
             name="EmployeeJaxRPC" 
             type="war">
    <classloader delegation="parentLast"/>
</application>
```

### 2. IBM WebSphere Liberty

#### Prerequisites
- WebSphere Liberty 17.0.0.3 or higher
- Java 8 or higher
- jaxrpc-2.2 feature enabled

#### Deployment Steps

1. **Configure server.xml**
   ```xml
   <server description="Liberty Server">
       <featureManager>
           <feature>jaxrpc-2.2</feature>
           <feature>servlet-3.1</feature>
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
   </server>
   ```

2. **Copy WAR File**
   ```bash
   cp dist/EmployeeJaxRPC.war $WLP_HOME/usr/servers/defaultServer/apps/
   ```

3. **Start Server**
   ```bash
   $WLP_HOME/bin/server start defaultServer
   ```

4. **Verify Deployment**
   ```
   http://localhost:9080/EmployeeJaxRPC/services
   ```

### 3. Apache Tomcat

#### Prerequisites
- Apache Tomcat 8.5 or higher
- Java 8 or higher
- Axis libraries (included in WAR)

#### Deployment Steps

1. **Copy WAR File**
   ```bash
   cp dist/EmployeeJaxRPC.war $CATALINA_HOME/webapps/
   ```

2. **Start Tomcat**
   ```bash
   $CATALINA_HOME/bin/startup.sh    # Linux/Mac
   $CATALINA_HOME/bin/startup.bat   # Windows
   ```

3. **Verify Deployment**
   ```
   http://localhost:8080/EmployeeJaxRPC/services
   ```

#### Tomcat-Specific Notes
- Tomcat will auto-deploy the WAR file
- Application will be available at context root `/EmployeeJaxRPC`
- Check logs at: `$CATALINA_HOME/logs/catalina.out`

### 4. Oracle WebLogic Server

#### Prerequisites
- WebLogic Server 12c or higher
- Java 8 or higher
- Administrative console access

#### Deployment Steps

1. **Access Admin Console**
   ```
   http://localhost:7001/console
   ```

2. **Deploy Application**
   - Navigate to: Deployments
   - Click: Install
   - Select: `dist/EmployeeJaxRPC.war`
   - Click: Next
   - Select: Install this deployment as an application
   - Click: Next → Finish

3. **Start Application**
   - Select: EmployeeJaxRPC
   - Click: Start → Servicing all requests

4. **Verify Deployment**
   ```
   http://localhost:7001/EmployeeJaxRPC/services
   ```

## Service Endpoints

After successful deployment, the following SOAP services will be available:

### 1. Employee Service (CRUD Operations)
```
Endpoint: http://[host]:[port]/EmployeeJaxRPC/services/EmployeeService
WSDL:     http://[host]:[port]/EmployeeJaxRPC/services/EmployeeService?wsdl

Operations:
- createEmployee
- getEmployee
- updateEmployee
- deleteEmployee
```

### 2. Employee Query Service (Search)
```
Endpoint: http://[host]:[port]/EmployeeJaxRPC/services/EmployeeQueryService
WSDL:     http://[host]:[port]/EmployeeJaxRPC/services/EmployeeQueryService?wsdl

Operations:
- searchEmployee
```

### 3. Department Service
```
Endpoint: http://[host]:[port]/EmployeeJaxRPC/services/DepartmentService
WSDL:     http://[host]:[port]/EmployeeJaxRPC/services/DepartmentService?wsdl

Operations:
- getDepartments
```

### 4. Authentication Service
```
Endpoint: http://[host]:[port]/EmployeeJaxRPC/services/AuthService
WSDL:     http://[host]:[port]/EmployeeJaxRPC/services/AuthService?wsdl

Operations:
- login
- logout
- validateToken
```

## Testing Deployed Services

### Using SoapUI

1. **Create New SOAP Project**
   - File → New SOAP Project
   - Project Name: EmployeeJaxRPC
   - Initial WSDL: `http://localhost:9080/EmployeeJaxRPC/services/EmployeeService?wsdl`

2. **Import All WSDLs**
   - Right-click project → Add WSDL
   - Add each service WSDL

3. **Test Operations**
   - Expand service → operation
   - Double-click request
   - Modify XML with test data
   - Click green arrow to send

### Using cURL

**Create Employee:**
```bash
curl -X POST http://localhost:9080/EmployeeJaxRPC/services/EmployeeService \
  -H "Content-Type: text/xml; charset=utf-8" \
  -H "SOAPAction: \"\"" \
  -d @samples/requests/CreateEmployee-Request.xml
```

**Get Employee:**
```bash
curl -X POST http://localhost:9080/EmployeeJaxRPC/services/EmployeeService \
  -H "Content-Type: text/xml; charset=utf-8" \
  -H "SOAPAction: \"\"" \
  -d @samples/requests/GetEmployee-Request.xml
```

**Search Employees:**
```bash
curl -X POST http://localhost:9080/EmployeeJaxRPC/services/EmployeeQueryService \
  -H "Content-Type: text/xml; charset=utf-8" \
  -H "SOAPAction: \"\"" \
  -d @samples/requests/SearchEmployee-Request.xml
```

### Using Java Client

```java
import com.example.employee.service.v1.*;

public class EmployeeClient {
    public static void main(String[] args) throws Exception {
        // Create service locator
        EmployeeServiceLocator locator = new EmployeeServiceLocator();
        
        // Get port
        EmployeePortType port = locator.getEmployeeService();
        
        // Create request
        CreateEmployeeRequest request = new CreateEmployeeRequest();
        EmployeeType employee = new EmployeeType();
        employee.setFirstName("John");
        employee.setLastName("Doe");
        employee.setEmail("john.doe@example.com");
        employee.setDepartmentId("IT");
        request.setEmployee(employee);
        
        // Call service
        CreateEmployeeResponse response = port.createEmployee(request);
        
        // Process response
        System.out.println("Employee ID: " + response.getEmployeeId());
        System.out.println("Status: " + response.getStatus().getCode());
    }
}
```

## Monitoring and Troubleshooting

### Log Files

**WebSphere:**
```
$WAS_HOME/profiles/[profile]/logs/[server]/SystemOut.log
$WAS_HOME/profiles/[profile]/logs/[server]/SystemErr.log
```

**Liberty:**
```
$WLP_HOME/usr/servers/[server]/logs/messages.log
$WLP_HOME/usr/servers/[server]/logs/console.log
```

**Tomcat:**
```
$CATALINA_HOME/logs/catalina.out
$CATALINA_HOME/logs/localhost.[date].log
```

### Common Issues

#### 1. ClassNotFoundException
**Symptom:** Service fails to start with class not found errors
**Solution:** 
- Verify all JAR files are in WEB-INF/lib
- Check classloader delegation (use parent-last)
- Rebuild WAR: `ant clean package`

#### 2. WSDL Not Accessible
**Symptom:** 404 error when accessing WSDL URL
**Solution:**
- Verify application is started
- Check context root configuration
- Verify Axis servlet mapping in web.xml

#### 3. SOAP Fault Errors
**Symptom:** SOAP fault responses
**Solution:**
- Check request XML format
- Verify namespace URIs
- Review server logs for stack traces
- Validate against WSDL schema

#### 4. Authentication Failures
**Symptom:** 401 or authentication errors
**Solution:**
- Verify credentials in request header
- Check AuthService is deployed
- Review token validation logic

### Performance Tuning

**JVM Options:**
```
-Xms512m
-Xmx2048m
-XX:+UseG1GC
-XX:MaxGCPauseMillis=200
```

**Connection Pool Settings:**
- Adjust thread pool size based on load
- Configure connection timeouts
- Enable HTTP keep-alive

## Security Considerations

### 1. Transport Security
- Enable HTTPS for production
- Configure SSL certificates
- Enforce TLS 1.2 or higher

### 2. Authentication
- Implement proper authentication mechanism
- Use secure token generation
- Validate all incoming requests

### 3. Input Validation
- All inputs are validated in service implementation
- XSD schema validation is enforced
- SQL injection prevention (if database is added)

### 4. Logging
- Sensitive data is masked in logs
- Audit trail for all operations
- Log rotation configured

## Backup and Recovery

### Backup Checklist
- [ ] WAR file: `dist/EmployeeJaxRPC.war`
- [ ] Configuration files: `config/*`
- [ ] WSDL files: `WSDLs/*`
- [ ] XSD schemas: `xsd/*`
- [ ] Build scripts: `build.xml`, `build.properties`
- [ ] Documentation: `*.md` files

### Recovery Steps
1. Undeploy existing application
2. Deploy backed-up WAR file
3. Verify all services are accessible
4. Run smoke tests
5. Monitor logs for errors

## Maintenance

### Regular Tasks
- Monitor log files for errors
- Review service performance metrics
- Update dependencies for security patches
- Backup configuration and deployment artifacts
- Test disaster recovery procedures

### Version Updates
1. Update version in `build.properties`
2. Rebuild: `ant clean package`
3. Test in staging environment
4. Deploy to production
5. Update documentation

## Support

### Resources
- Project README: `README.md`
- Quick Start Guide: `QUICKSTART.md`
- Build Commands: `BUILD_COMMANDS.txt`
- Dependencies: `lib/DEPENDENCIES.md`

### Contact
For issues or questions, refer to project documentation or contact the development team.

---

**Document Version:** 1.0.0  
**Last Updated:** 2026-05-07  
**Author:** EmployeeJaxRPC Development Team