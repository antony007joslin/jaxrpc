# ================================================================
# Download JAX-RPC Dependencies from Maven Central
# ================================================================
# This script downloads all required JAR files for the EmployeeJaxRPC project
# Run this script from the project root directory

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  Downloading JAX-RPC Dependencies from Maven Central" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# Ensure lib directory exists
if (-not (Test-Path "lib")) {
    Write-Host "Creating lib directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path "lib" | Out-Null
}

# Change to lib directory
Set-Location lib

# Define dependencies with their Maven Central URLs
$dependencies = @(
    @{
        Name = "axis.jar"
        Url = "https://repo1.maven.org/maven2/org/apache/axis/axis/1.4/axis-1.4.jar"
        Description = "Apache Axis 1.4 - Main library"
    },
    @{
        Name = "jaxrpc.jar"
        Url = "https://repo1.maven.org/maven2/javax/xml/jaxrpc-api/1.1/jaxrpc-api-1.1.jar"
        Description = "JAX-RPC API 1.1"
    },
    @{
        Name = "saaj.jar"
        Url = "https://repo1.maven.org/maven2/javax/xml/soap/saaj-api/1.3/saaj-api-1.3.jar"
        Description = "SAAJ API 1.3"
    },
    @{
        Name = "wsdl4j-1.5.1.jar"
        Url = "https://repo1.maven.org/maven2/wsdl4j/wsdl4j/1.5.1/wsdl4j-1.5.1.jar"
        Description = "WSDL4J 1.5.1"
    },
    @{
        Name = "commons-discovery-0.2.jar"
        Url = "https://repo1.maven.org/maven2/commons-discovery/commons-discovery/0.2/commons-discovery-0.2.jar"
        Description = "Commons Discovery 0.2"
    },
    @{
        Name = "commons-logging-1.0.4.jar"
        Url = "https://repo1.maven.org/maven2/commons-logging/commons-logging/1.0.4/commons-logging-1.0.4.jar"
        Description = "Commons Logging 1.0.4"
    },
    @{
        Name = "activation.jar"
        Url = "https://repo1.maven.org/maven2/javax/activation/activation/1.1/activation-1.1.jar"
        Description = "JavaBeans Activation Framework 1.1"
    },
    @{
        Name = "mail.jar"
        Url = "https://repo1.maven.org/maven2/javax/mail/mail/1.4/mail-1.4.jar"
        Description = "JavaMail API 1.4"
    },
    @{
        Name = "log4j-1.2.17.jar"
        Url = "https://repo1.maven.org/maven2/log4j/log4j/1.2.17/log4j-1.2.17.jar"
        Description = "Log4j 1.2.17"
    },
    @{
        Name = "axis-ant.jar"
        Url = "https://repo1.maven.org/maven2/org/apache/axis/axis-ant/1.4/axis-ant-1.4.jar"
        Description = "Apache Axis ANT Tasks 1.4"
    }
)

$successCount = 0
$failCount = 0
$totalCount = $dependencies.Count

Write-Host "Starting download of $totalCount dependencies..." -ForegroundColor Green
Write-Host ""

foreach ($dep in $dependencies) {
    $fileName = $dep.Name
    $url = $dep.Url
    $description = $dep.Description
    
    Write-Host "[$($successCount + $failCount + 1)/$totalCount] Downloading: $fileName" -ForegroundColor Cyan
    Write-Host "  Description: $description" -ForegroundColor Gray
    Write-Host "  URL: $url" -ForegroundColor Gray
    
    try {
        # Check if file already exists
        if (Test-Path $fileName) {
            Write-Host "  Status: Already exists, skipping..." -ForegroundColor Yellow
            $successCount++
        } else {
            # Download the file
            Invoke-WebRequest -Uri $url -OutFile $fileName -ErrorAction Stop
            
            # Verify download
            if (Test-Path $fileName) {
                $fileSize = (Get-Item $fileName).Length
                $fileSizeKB = [math]::Round($fileSize / 1KB, 2)
                Write-Host "  Status: Downloaded successfully ($fileSizeKB KB)" -ForegroundColor Green
                $successCount++
            } else {
                Write-Host "  Status: Download failed - file not found" -ForegroundColor Red
                $failCount++
            }
        }
    }
    catch {
        Write-Host "  Status: Download failed - $($_.Exception.Message)" -ForegroundColor Red
        $failCount++
    }
    
    Write-Host ""
}

# Return to project root
Set-Location ..

# Summary
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  Download Summary" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "Total dependencies: $totalCount" -ForegroundColor White
Write-Host "Successfully downloaded/verified: $successCount" -ForegroundColor Green
Write-Host "Failed: $failCount" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "Green" })
Write-Host ""

# List downloaded files
if ($successCount -gt 0) {
    Write-Host "Files in lib directory:" -ForegroundColor Cyan
    Get-ChildItem -Path "lib" -Filter "*.jar" | ForEach-Object {
        $size = [math]::Round($_.Length / 1KB, 2)
        Write-Host "  $($_.Name) - $size KB" -ForegroundColor White
    }
    Write-Host ""
}

# Final status
if ($failCount -eq 0) {
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host "  SUCCESS! All dependencies downloaded successfully." -ForegroundColor Green
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Run: ant all" -ForegroundColor White
    Write-Host "  2. Deploy: dist\EmployeeJaxRPC.war" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "================================================================" -ForegroundColor Red
    Write-Host "  WARNING! Some dependencies failed to download." -ForegroundColor Red
    Write-Host "================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please check your internet connection and try again." -ForegroundColor Yellow
    Write-Host "Or download manually from Maven Central." -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Made with Bob
