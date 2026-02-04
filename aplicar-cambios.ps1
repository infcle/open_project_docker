# Script para aplicar cambios de configuración de OpenProject
# Ejecuta: powershell -ExecutionPolicy Bypass -File aplicar-cambios.ps1

Write-Host "============================================" -ForegroundColor Green
Write-Host "Aplicando cambios de configuración" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""

# 1. Obtener IP local
Write-Host "1. Obteniendo IP local..." -ForegroundColor Cyan
$ipOutput = ipconfig | Select-String "IPv4"
$localIP = ($ipOutput | Where-Object { $_ -notmatch "172\.18\." -and $_ -notmatch "172\.30\." } | Select-Object -First 1) -replace ".*:\s*", ""

if ([string]::IsNullOrEmpty($localIP)) {
    $localIP = ($ipOutput | Select-Object -First 1) -replace ".*:\s*", ""
}

Write-Host "   IP local encontrada: $localIP" -ForegroundColor Yellow
Write-Host ""

# 2. Verificar archivo .env
Write-Host "2. Verificando archivo .env..." -ForegroundColor Cyan
if (Test-Path ".env") {
    Write-Host "   Archivo .env encontrado" -ForegroundColor Green
    
    # Actualizar OPENPROJECT_HOST__NAME
    $envContent = Get-Content ".env" -Raw
    $envContent = $envContent -replace "OPENPROJECT_HOST__NAME=.*", "OPENPROJECT_HOST__NAME=$localIP:8082"
    Set-Content ".env" -Value $envContent -NoNewline
    Write-Host "   OPENPROJECT_HOST__NAME actualizado a: $localIP:8082" -ForegroundColor Green
} else {
    Write-Host "   Creando archivo .env desde template..." -ForegroundColor Yellow
    Copy-Item "env.template" ".env"
    
    # Actualizar OPENPROJECT_HOST__NAME
    $envContent = Get-Content ".env" -Raw
    $envContent = $envContent -replace "OPENPROJECT_HOST__NAME=.*", "OPENPROJECT_HOST__NAME=$localIP:8082"
    Set-Content ".env" -Value $envContent -NoNewline
    Write-Host "   Archivo .env creado y configurado" -ForegroundColor Green
}
Write-Host ""

# 3. Configurar Firewall
Write-Host "3. Configurando Firewall de Windows..." -ForegroundColor Cyan
try {
    $existingRule = Get-NetFirewallRule -DisplayName "OpenProject" -ErrorAction SilentlyContinue
    if ($existingRule) {
        Write-Host "   Regla de firewall ya existe" -ForegroundColor Yellow
    } else {
        New-NetFirewallRule -DisplayName "OpenProject" -Direction Inbound -LocalPort 8082 -Protocol TCP -Action Allow | Out-Null
        Write-Host "   Regla de firewall creada exitosamente" -ForegroundColor Green
    }
} catch {
    Write-Host "   ERROR: No se pudo crear la regla de firewall" -ForegroundColor Red
    Write-Host "   Necesitas ejecutar este script como Administrador" -ForegroundColor Yellow
    Write-Host "   O crear la regla manualmente desde el Firewall de Windows" -ForegroundColor Yellow
}
Write-Host ""

# 4. Recrear contenedores
Write-Host "4. Recreando contenedores..." -ForegroundColor Cyan
Write-Host "   Esto puede tardar unos minutos..." -ForegroundColor Yellow
docker-compose down
docker-compose up -d --force-recreate
Write-Host ""

# 5. Mostrar información
Write-Host "============================================" -ForegroundColor Green
Write-Host "Configuración completada!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Acceso desde tu máquina:" -ForegroundColor Cyan
Write-Host "  http://localhost:8082" -ForegroundColor Yellow
Write-Host ""
Write-Host "Acceso desde otros dispositivos en la red:" -ForegroundColor Cyan
Write-Host "  http://$localIP:8082" -ForegroundColor Yellow
Write-Host ""
Write-Host "Credenciales por defecto:" -ForegroundColor Cyan
Write-Host "  Usuario: admin" -ForegroundColor Yellow
Write-Host "  Contraseña: admin" -ForegroundColor Yellow
Write-Host ""
Write-Host "Para ver los logs:" -ForegroundColor Cyan
Write-Host "  docker-compose logs -f" -ForegroundColor Yellow
Write-Host ""
