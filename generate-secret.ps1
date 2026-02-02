# Script para generar una clave secreta segura para OpenProject
# Ejecuta: powershell -ExecutionPolicy Bypass -File generate-secret.ps1

$length = 64
$chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:,.<>?'
$random = New-Object System.Random
$secret = -join (1..$length | ForEach-Object { $chars[$random.Next($chars.Length)] })

Write-Host "============================================" -ForegroundColor Green
Write-Host "Clave secreta generada:" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host $secret -ForegroundColor Yellow
Write-Host ""
Write-Host "Copia esta clave y pégala en el archivo .env" -ForegroundColor Cyan
Write-Host "en la variable OPENPROJECT_SECRET_KEY_BASE" -ForegroundColor Cyan
Write-Host ""

# Copiar al portapapeles
$secret | Set-Clipboard
Write-Host "¡La clave ha sido copiada al portapapeles!" -ForegroundColor Green
