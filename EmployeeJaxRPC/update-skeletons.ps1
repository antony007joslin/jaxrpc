# Script to update skeleton files to use custom implementation classes
# Run this after each build to fix the skeleton constructors

Write-Host "Updating skeleton files..." -ForegroundColor Green

# Update EmployeeBindingSkeleton
$file = "generated/java/com/example/employee/service/v1/EmployeeBindingSkeleton.java"
$content = Get-Content $file -Raw
$content = $content -replace 'this\.impl = new com\.example\.employee\.service\.v1\.EmployeeBindingImpl\(\);', 'this.impl = new com.example.employee.service.v1.EmployeeServiceImpl();'
Set-Content $file $content
Write-Host "✓ Updated EmployeeBindingSkeleton.java" -ForegroundColor Cyan

# Update EmployeeQueryBindingSkeleton
$file = "generated/java/com/example/employee/service/v1/EmployeeQueryBindingSkeleton.java"
$content = Get-Content $file -Raw
$content = $content -replace 'this\.impl = new com\.example\.employee\.service\.v1\.EmployeeQueryBindingImpl\(\);', 'this.impl = new com.example.employee.service.v1.EmployeeQueryServiceImpl();'
Set-Content $file $content
Write-Host "✓ Updated EmployeeQueryBindingSkeleton.java" -ForegroundColor Cyan

# Update DepartmentBindingSkeleton
$file = "generated/java/com/example/department/service/v1/DepartmentBindingSkeleton.java"
$content = Get-Content $file -Raw
$content = $content -replace 'this\.impl = new com\.example\.department\.service\.v1\.DepartmentBindingImpl\(\);', 'this.impl = new com.example.department.service.v1.DepartmentServiceImpl();'
Set-Content $file $content
Write-Host "✓ Updated DepartmentBindingSkeleton.java" -ForegroundColor Cyan

# Update AuthBindingSkeleton
$file = "generated/java/com/example/auth/service/v1/AuthBindingSkeleton.java"
$content = Get-Content $file -Raw
$content = $content -replace 'this\.impl = new com\.example\.auth\.service\.v1\.AuthBindingImpl\(\);', 'this.impl = new com.example.auth.service.v1.AuthServiceImpl();'
Set-Content $file $content
Write-Host "✓ Updated AuthBindingSkeleton.java" -ForegroundColor Cyan

Write-Host "`nAll skeleton files updated successfully!" -ForegroundColor Green
Write-Host "Now run: ant compile package" -ForegroundColor Yellow

# Made with Bob
