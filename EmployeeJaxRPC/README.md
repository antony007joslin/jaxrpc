# Employee JAX-RPC Web Services

Enterprise SOAP Web Services implementation using JAX-RPC (Apache Axis) for Employee Management System.

## Overview

This project provides a complete enterprise-grade SOAP web services implementation following the contract-first approach using WSDL and XSD schemas. The implementation uses JAX-RPC APIs with Apache Axis for backward compatibility with legacy enterprise systems.

### Services Provided

1. **EmployeeService** - CRUD operations for employee management
   - CreateEmployee
   - UpdateEmployee
   - GetEmployee
   - DeleteEmployee

2. **EmployeeQueryService** - Search and query operations
   - SearchEmployee (by department)

3. **DepartmentService** - Department information
   - GetDepartments

4. **AuthService** - Authentication and authorization
   - Login

## Project Structure

```
EmployeeJaxRPC/
├── build.xml                    # ANT build script
├── build.properties             # Build configuration
├── README.md                    # This file
│
├── WSDLs/                       # WSDL contracts
│   ├── EmployeeService.wsdl
│   ├── EmployeeQuery.wsdl
│   ├── DepartmentService.wsdl
│   └── AuthService.wsdl
│
├── xsd/                         # XML Schema definitions
│   ├── employee/
│   │   ├── employee-types.xsd
│   │   └── employee-service-types.xsd
│   ├── common/
│   │   ├── common-types.xsd
│   │   ├── header-types.xsd
│   │   └── department-types.xsd
│   └── auth/
│       └── auth-types.xsd
│
├── src/main/java/               # Implementation source code
│   └── com/example/
│       ├── employee/service/v1/
│       │   ├── EmployeeServiceImpl.java
│       │   └── EmployeeQueryServiceImpl.java
│       ├── department/service/v1/
│       │   └── DepartmentServiceImpl.java
│       └── auth/service/v1/
│           └── AuthServiceImpl.java
│
├── src/main/resources/          # Configuration resources
│   └── log4j.properties
│
├── generated/java/              # Generated JAX-RPC artifacts (created by build)
│
├── config/                      # Deployment descriptors
│   ├── web.xml
│   ├── server-config.wsdd
│   └── jaxrpc-mapping.xml
│
├── lib/                         # Required JAR dependencies
│
├── classes/                     # Compiled classes (created by build)
│
├── dist/                        # Distribution artifacts (created by build)
│   └── EmployeeJaxRPC.war
│
└── samples/                     # Sample SOAP requests/responses
    ├── requests/
    └── responses/
```

## Prerequisites

### Required Software

1. **Java Development Kit (JDK)**
   - Version: 1.8 or higher
   - Set JAVA_HOME environment variable

2. **Apache ANT**
   - Version: 1.9.x or higher
   - Set ANT_HOME environment variable
   - Add ANT_HOME/bin to PATH

3. **Application Server** (one of the following)
   - IBM WebSphere Application Server 8.5+
   - IBM WebSphere Liberty Profile
   - Apache Tomcat 7.0+ (with Axis libraries)

### Required JAR Dependencies

Place the following JAR files in the `lib/` directory:

#### Apache Axis JAX-RPC Libraries
- `axis.jar` (v1.4 or higher)
- `jaxrpc.jar`
- `saaj.jar`
- `wsdl4j-1.5.1.jar`

#### Apache Commons Libraries
- `commons-discovery-0.2.jar`
- `commons-logging-1.0.4.jar`

#### Java Activation & Mail
- `activation.jar`
- `mail.jar`

#### Logging
- `log4j-1.2.17.jar`

#### Servlet API (provided by application server)
- `servlet-api.jar` (for compilation only)

### Download Dependencies

You can download Apache Axis from:
- https://axis.apache.org/axis/java/index.html

Or use Maven Central to download individual JARs.

## Build Instructions

### 1. Setup Environment

```bash
# Set JAVA_HOME
export JAVA_HOME=/path/to/jdk
export PATH=$JAVA_HOME/bin:$PATH

# Set ANT_HOME
export ANT_HOME=/path/to/ant
export PATH=$ANT_HOME/bin:$PATH

# Verify installations
java -version
ant -version
```

### 2. Prepare Dependencies

```bash
# Create lib directory if not exists
mkdir -p lib

# Copy all required JAR files to lib/ directory
# (Download from Apache Axis distribution or Maven Central)
```

### 3. Build the Project

```bash
# Clean previous build artifacts
ant clean

# Generate Java artifacts from WSDLs
ant generate

# Compile all sources
ant compile

# Package as WAR file
ant package

# Or do everything in one command
ant all
```

### Build Targets

- `ant clean` - Remove all build artifacts
- `ant generate` - Generate Java code from WSDL files
- `ant compile` - Compile Java sources
- `ant package` - Create WAR file
- `ant deploy` - Deploy to application server (configure first)
- `ant all` - Clean and build everything
- `ant help` - Display available targets

## Deployment Instructions

### IBM WebSphere Application Server

1. **Using Admin Console:**
   ```
   - Login to WebSphere Admin Console
   - Navigate to Applications > New Application > New Enterprise Application
   - Select dist/EmployeeJaxRPC.war
   - Follow the installation wizard
   - Start the application
   ```

2. **Using wsadmin:**
   ```bash
   wsadmin -lang jython -c "AdminApp.install('dist/EmployeeJaxRPC.war', '[-appname EmployeeJaxRPC -contextroot /EmployeeJaxRPC]')"
   wsadmin -lang jython -c "AdminConfig.save()"
   ```

### IBM WebSphere Liberty

1. **Copy WAR to dropins:**
   ```bash
   cp dist/EmployeeJaxRPC.war $WLP_HOME/usr/servers/defaultServer/dropins/
   ```

2. **Or configure in server.xml:**
   ```xml
   <application location="EmployeeJaxRPC.war" name="EmployeeJaxRPC"/>
   ```

### Apache Tomcat

1. **Copy WAR to webapps:**
   ```bash
   cp dist/EmployeeJaxRPC.war $CATALINA_HOME/webapps/
   ```

2. **Start Tomcat:**
   ```bash
   $CATALINA_HOME/bin/startup.sh
   ```

## Testing the Services

### Service Endpoints

After deployment, services will be available at:

```
http://localhost:8080/EmployeeJaxRPC/services/EmployeeService
http://localhost:8080/EmployeeJaxRPC/services/EmployeeQueryService
http://localhost:8080/EmployeeJaxRPC/services/DepartmentService
http://localhost:8080/EmployeeJaxRPC/services/AuthService
```

### View WSDL

Access WSDL documents at:

```
http://localhost:8080/EmployeeJaxRPC/services/EmployeeService?wsdl
http://localhost:8080/EmployeeJaxRPC/services/EmployeeQueryService?wsdl
http://localhost:8080/EmployeeJaxRPC/services/DepartmentService?wsdl
http://localhost:8080/EmployeeJaxRPC/services/AuthService?wsdl
```

### Using SOAP UI

1. Create new SOAP project in SOAP UI
2. Import WSDL from service endpoint
3. Use sample requests from `samples/requests/` directory
4. Execute requests and verify responses

### Using cURL

```bash
# Login Request
curl -X POST http://localhost:8080/EmployeeJaxRPC/services/AuthService \
  -H "Content-Type: text/xml" \
  -H "SOAPAction: login" \
  -d @samples/requests/Login-Request.xml

# Get Departments
curl -X POST http://localhost:8080/EmployeeJaxRPC/services/DepartmentService \
  -H "Content-Type: text/xml" \
  -H "SOAPAction: http://example.com/department/service/v1/GetDepartments" \
  -d @samples/requests/GetDepartments-Request.xml

# Create Employee
curl -X POST http://localhost:8080/EmployeeJaxRPC/services/EmployeeService \
  -H "Content-Type: text/xml" \
  -H "SOAPAction: CreateEmployee" \
  -d @samples/requests/CreateEmployee-Request.xml
```

## Configuration

### Logging Configuration

Edit `src/main/resources/log4j.properties` to configure logging:

```properties
# Set log level
log4j.logger.com.example.employee=DEBUG

# Change log file location
log4j.appender.file.File=/path/to/logs/employee-jaxrpc.log
```

### Service Configuration

Edit `config/server-config.wsdd` to modify service parameters:

- Scope (Request, Session, Application)
- Allowed methods
- Type mappings
- Handler chains

### Build Configuration

Edit `build.properties` to customize:

- Java version
- Package names
- Server paths
- Deployment directories

## Sample Requests

Sample SOAP requests are provided in `samples/requests/`:

1. **Login-Request.xml** - Authenticate user
2. **GetDepartments-Request.xml** - Retrieve all departments
3. **CreateEmployee-Request.xml** - Create new employee
4. **GetEmployee-Request.xml** - Retrieve employee by ID
5. **SearchEmployee-Request.xml** - Search employees by department

## Development

### Adding New Operations

1. Update WSDL file with new operation
2. Update XSD if new types are needed
3. Run `ant generate` to regenerate artifacts
4. Implement operation in service implementation class
5. Update server-config.wsdd with operation mapping
6. Rebuild and redeploy

### Modifying Existing Operations

1. Update WSDL/XSD as needed
2. Regenerate artifacts: `ant clean generate`
3. Update implementation code
4. Rebuild: `ant compile package`
5. Redeploy application

## Troubleshooting

### Build Issues

**Problem:** WSDL generation fails
```
Solution: Ensure all XSD files are accessible and namespace imports are correct
```

**Problem:** Compilation errors
```
Solution: Verify all required JARs are in lib/ directory
```

### Deployment Issues

**Problem:** ClassNotFoundException
```
Solution: Ensure all Axis JARs are included in WEB-INF/lib
```

**Problem:** Service not found
```
Solution: Check server-config.wsdd is in WEB-INF directory
```

### Runtime Issues

**Problem:** SOAP Fault - Method not found
```
Solution: Verify operation name matches WSDL and server-config.wsdd
```

**Problem:** Namespace errors
```
Solution: Ensure namespace mappings in server-config.wsdd match WSDL
```

## Security Considerations

### Production Deployment

1. **Authentication:**
   - Replace in-memory user store with database
   - Use secure password hashing (BCrypt, PBKDF2)
   - Implement proper token management (JWT)

2. **Authorization:**
   - Add role-based access control
   - Implement method-level security
   - Use WS-Security headers

3. **Transport Security:**
   - Enable HTTPS/TLS
   - Use certificate-based authentication
   - Configure SSL in application server

4. **Input Validation:**
   - Validate all input parameters
   - Sanitize data to prevent injection attacks
   - Implement schema validation

## Performance Tuning

1. **Connection Pooling:**
   - Configure database connection pools
   - Tune pool sizes based on load

2. **Caching:**
   - Cache frequently accessed data
   - Use distributed cache for scalability

3. **Thread Management:**
   - Configure thread pools in application server
   - Monitor thread usage

4. **Logging:**
   - Set appropriate log levels in production
   - Use asynchronous logging

## Monitoring

### Log Files

- Application logs: `${catalina.base}/logs/employee-jaxrpc.log`
- Performance logs: `${catalina.base}/logs/performance.log`
- Security audit: `${catalina.base}/logs/security-audit.log`

### Metrics

Monitor:
- Request/response times
- Error rates
- Active sessions
- Memory usage
- Thread pool utilization

## Support

For issues or questions:
- Check troubleshooting section
- Review Apache Axis documentation
- Consult application server documentation

## License

Enterprise Internal Use Only

## Version History

- **1.0.0** - Initial release
  - Employee CRUD operations
  - Department queries
  - Employee search
  - Authentication service
  - Complete JAX-RPC implementation
  - ANT-based build system