# Required JAR Dependencies

This document lists all required JAR files for the EmployeeJaxRPC project.

## Apache Axis JAX-RPC Libraries

### Core Axis Libraries
- **axis.jar** (v1.4)
  - Main Apache Axis library
  - Download: https://axis.apache.org/axis/java/index.html
  - Maven: `org.apache.axis:axis:1.4`

- **jaxrpc.jar** (v1.1)
  - JAX-RPC API implementation
  - Included in Axis distribution
  - Maven: `javax.xml:jaxrpc-api:1.1`

- **saaj.jar** (v1.2)
  - SOAP with Attachments API for Java
  - Included in Axis distribution
  - Maven: `javax.xml.soap:saaj-api:1.3`

- **wsdl4j-1.5.1.jar**
  - WSDL4J library for WSDL parsing
  - Included in Axis distribution
  - Maven: `wsdl4j:wsdl4j:1.5.1`

## Apache Commons Libraries

- **commons-discovery-0.2.jar**
  - Service discovery library
  - Required by Axis
  - Maven: `commons-discovery:commons-discovery:0.2`

- **commons-logging-1.0.4.jar**
  - Logging abstraction layer
  - Required by Axis
  - Maven: `commons-logging:commons-logging:1.0.4`

## Java Activation & Mail

- **activation.jar** (v1.1)
  - JavaBeans Activation Framework
  - Required for SOAP attachments
  - Maven: `javax.activation:activation:1.1`

- **mail.jar** (v1.4)
  - JavaMail API
  - Required for SOAP attachments
  - Maven: `javax.mail:mail:1.4`

## Logging

- **log4j-1.2.17.jar**
  - Log4j logging framework
  - Maven: `log4j:log4j:1.2.17`

## Servlet API (Provided by Server)

- **servlet-api.jar** (v3.0+)
  - Java Servlet API
  - Provided by application server
  - Only needed for compilation
  - Maven: `javax.servlet:javax.servlet-api:3.0.1` (scope: provided)

## Download Instructions

### Option 1: Download Apache Axis Distribution

1. Download Apache Axis 1.4 from:
   https://axis.apache.org/axis/java/index.html

2. Extract the archive

3. Copy the following JARs from `axis-1_4/lib/` to this `lib/` directory:
   - axis.jar
   - jaxrpc.jar
   - saaj.jar
   - wsdl4j-1.5.1.jar
   - commons-discovery-0.2.jar
   - commons-logging-1.0.4.jar

4. Download additional dependencies:
   - activation.jar from https://www.oracle.com/java/technologies/javase-jaf-downloads.html
   - mail.jar from https://javaee.github.io/javamail/
   - log4j-1.2.17.jar from https://logging.apache.org/log4j/1.2/

### Option 2: Use Maven to Download JARs

Create a temporary pom.xml and use Maven to download dependencies:

```xml
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>temp</groupId>
    <artifactId>temp</artifactId>
    <version>1.0</version>
    
    <dependencies>
        <dependency>
            <groupId>org.apache.axis</groupId>
            <artifactId>axis</artifactId>
            <version>1.4</version>
        </dependency>
        <dependency>
            <groupId>javax.xml</groupId>
            <artifactId>jaxrpc-api</artifactId>
            <version>1.1</version>
        </dependency>
        <dependency>
            <groupId>wsdl4j</groupId>
            <artifactId>wsdl4j</artifactId>
            <version>1.5.1</version>
        </dependency>
        <dependency>
            <groupId>commons-discovery</groupId>
            <artifactId>commons-discovery</artifactId>
            <version>0.2</version>
        </dependency>
        <dependency>
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
            <version>1.0.4</version>
        </dependency>
        <dependency>
            <groupId>javax.activation</groupId>
            <artifactId>activation</artifactId>
            <version>1.1</version>
        </dependency>
        <dependency>
            <groupId>javax.mail</groupId>
            <artifactId>mail</artifactId>
            <version>1.4</version>
        </dependency>
        <dependency>
            <groupId>log4j</groupId>
            <artifactId>log4j</artifactId>
            <version>1.2.17</version>
        </dependency>
    </dependencies>
</project>
```

Then run:
```bash
mvn dependency:copy-dependencies -DoutputDirectory=lib
```

### Option 3: Download from Maven Central

Direct download links from Maven Central:

1. **axis.jar**
   https://repo1.maven.org/maven2/org/apache/axis/axis/1.4/axis-1.4.jar

2. **jaxrpc.jar**
   https://repo1.maven.org/maven2/javax/xml/jaxrpc-api/1.1/jaxrpc-api-1.1.jar

3. **saaj.jar**
   https://repo1.maven.org/maven2/javax/xml/soap/saaj-api/1.3/saaj-api-1.3.jar

4. **wsdl4j-1.5.1.jar**
   https://repo1.maven.org/maven2/wsdl4j/wsdl4j/1.5.1/wsdl4j-1.5.1.jar

5. **commons-discovery-0.2.jar**
   https://repo1.maven.org/maven2/commons-discovery/commons-discovery/0.2/commons-discovery-0.2.jar

6. **commons-logging-1.0.4.jar**
   https://repo1.maven.org/maven2/commons-logging/commons-logging/1.0.4/commons-logging-1.0.4.jar

7. **activation.jar**
   https://repo1.maven.org/maven2/javax/activation/activation/1.1/activation-1.1.jar

8. **mail.jar**
   https://repo1.maven.org/maven2/javax/mail/mail/1.4/mail-1.4.jar

9. **log4j-1.2.17.jar**
   https://repo1.maven.org/maven2/log4j/log4j/1.2.17/log4j-1.2.17.jar

## Verification

After placing all JARs in the `lib/` directory, verify with:

```bash
ls -la lib/
```

You should see:
```
activation.jar
axis.jar
commons-discovery-0.2.jar
commons-logging-1.0.4.jar
jaxrpc.jar
log4j-1.2.17.jar
mail.jar
saaj.jar
wsdl4j-1.5.1.jar
```

## License Information

- Apache Axis: Apache License 2.0
- Apache Commons: Apache License 2.0
- Log4j: Apache License 2.0
- JavaMail: CDDL/GPLv2 with Classpath Exception
- Activation: CDDL/GPLv2 with Classpath Exception

Ensure compliance with all licenses for your deployment environment.