# Apache Axis 1.4 and Jakarta EE 10 Compatibility Issue

## Problem Summary

Apache Axis 1.4 **cannot run on Jakarta EE 10** (OpenLiberty 26.0.0.3) due to a fundamental namespace incompatibility:

- **Apache Axis 1.4** (released 2006): Uses `javax.servlet.*` namespace (Java EE)
- **Jakarta EE 10** (2022+): Uses `jakarta.servlet.*` namespace

## Current Error

```
SRVE0276E: Error while initializing Servlet [AxisServlet]: 
jakarta.servlet.UnavailableException: SRVE0203E: Servlet [AxisServlet]: 
org.apache.axis.transport.http.AxisServlet was found, but is missing another required class.
```

The Axis servlets are compiled against `javax.servlet.HttpServlet` but Liberty is providing `jakarta.servlet.HttpServlet`.

## Solutions

### Option 1: Use Java EE 8 Compatible Liberty (RECOMMENDED)

Download and use **OpenLiberty 23.0.0.x** or **WebSphere Liberty with Java EE 8 support**:

1. **Download OpenLiberty 23.0.0.12** (Last version with Java EE 8):
   ```
   https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/23.0.0.12/
   ```

2. **Install and configure**:
   ```xml
   <featureManager>
       <feature>servlet-4.0</feature>
       <feature>jsp-2.3</feature>
   </featureManager>
   ```

3. **Deploy the application** - It will work without modifications

### Option 2: Migrate to Apache CXF (Modern Alternative)

Apache CXF is the modern successor to Axis and supports both JAX-WS and JAX-RS:

**Advantages:**
- Actively maintained
- Jakarta EE 10 compatible
- Better performance
- More features

**Migration Steps:**
1. Replace Axis dependencies with CXF
2. Update service implementations (minimal changes)
3. Regenerate artifacts from WSDLs using CXF tools
4. Update deployment descriptors

### Option 3: Use Bytecode Transformation (Complex)

Use Eclipse Transformer to convert Axis JARs from `javax.*` to `jakarta.*`:

```powershell
java -jar transformer.jar axis.jar axis-jakarta.jar
```

**Challenges:**
- May not work for all classes
- Requires testing all functionality
- Maintenance burden

## Recommended Action

**Use Option 1**: Download OpenLiberty 23.0.0.12 (Java EE 8 compatible)

### Quick Setup:

1. **Download**:
   ```
   https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/23.0.0.12/openliberty-javaee8-23.0.0.12.zip
   ```

2. **Extract** to `C:\liberty\openliberty-javaee8-23.0.0.12\`

3. **Create server**:
   ```powershell
   cd C:\liberty\openliberty-javaee8-23.0.0.12\wlp\bin
   .\server.bat create employeejaxrpc
   ```

4. **Copy server.xml** (use servlet-4.0):
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <server description="Employee JAX-RPC SOAP Services">
       <featureManager>
           <feature>servlet-4.0</feature>
           <feature>jsp-2.3</feature>
       </featureManager>
       
       <httpEndpoint id="defaultHttpEndpoint"
                     host="*"
                     httpPort="9080"
                     httpsPort="9443">
           <tcpOptions soReuseAddr="true"/>
       </httpEndpoint>
       
       <application id="EmployeeJaxRPC" 
                    location="EmployeeJaxRPC.war" 
                    name="EmployeeJaxRPC" 
                    type="war"
                    context-root="/EmployeeJaxRPC">
           <classloader delegation="parentLast"/>
       </application>
       
       <logging consoleLogLevel="INFO" 
                traceSpecification="*=info:com.example.*=all"/>
   </server>
   ```

5. **Deploy WAR**:
   ```powershell
   Copy-Item "dist\EmployeeJaxRPC.war" -Destination "C:\liberty\openliberty-javaee8-23.0.0.12\wlp\usr\servers\employeejaxrpc\apps\"
   ```

6. **Start server**:
   ```powershell
   .\server.bat run employeejaxrpc
   ```

7. **Test**:
   ```
   http://localhost:9080/EmployeeJaxRPC/services/DepartmentService?wsdl
   ```

## Why This Matters

- **Apache Axis 1.4** was last updated in 2006 (18 years ago)
- **Java EE to Jakarta EE** transition happened in 2019
- **Namespace change** (`javax.*` → `jakarta.*`) is not backward compatible
- **No patches** available for Axis 1.4 to support Jakarta EE

## Alternative: Modern SOAP with CXF

If you want to use Jakarta EE 10, consider migrating to Apache CXF:

```xml
<!-- CXF Dependencies -->
<dependency>
    <groupId>org.apache.cxf</groupId>
    <artifactId>cxf-rt-frontend-jaxws</artifactId>
    <version>4.0.3</version>
</dependency>
```

CXF provides:
- JAX-WS 4.0 (Jakarta EE 10)
- Better performance
- Active development
- Modern features

## Current Project Status

- ✅ WSDLs defined
- ✅ Service implementations complete
- ✅ Build system working
- ❌ **Runtime incompatibility** (Axis 1.4 + Jakarta EE 10)

## Next Steps

1. **Download OpenLiberty 23.0.0.12** (Java EE 8)
2. **Setup new server** with servlet-4.0
3. **Deploy existing WAR** (no code changes needed)
4. **Test services** - Should work immediately

---

**Made with Bob**