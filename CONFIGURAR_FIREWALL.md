# 🔥 Configurar Firewall de Windows

Para que otros dispositivos en tu red local puedan acceder a OpenProject, necesitas permitir el puerto 8082 en el firewall de Windows.

## ⚠️ IMPORTANTE: Ejecuta como Administrador

## Opción 1: PowerShell (Recomendado)

1. **Abre PowerShell como Administrador:**
   - Click derecho en el menú Inicio
   - Selecciona "Windows PowerShell (Administrador)" o "Terminal (Administrador)"

2. **Ejecuta este comando:**
   ```powershell
   New-NetFirewallRule -DisplayName "OpenProject" -Direction Inbound -LocalPort 8082 -Protocol TCP -Action Allow
   ```

3. **Verifica que se creó:**
   ```powershell
   Get-NetFirewallRule -DisplayName "OpenProject"
   ```

## Opción 2: Interfaz Gráfica

1. **Abre el Firewall de Windows:**
   - Presiona `Win + R`
   - Escribe: `wf.msc` y presiona Enter

2. **Crea la regla:**
   - Click en **"Reglas de entrada"** (Inbound Rules) en el panel izquierdo
   - Click en **"Nueva regla..."** (New Rule...) en el panel derecho

3. **Configura la regla:**
   - Selecciona **"Puerto"** → Siguiente
   - Selecciona **"TCP"**
   - Selecciona **"Puertos locales específicos"**
   - Escribe: `8082` → Siguiente
   - Selecciona **"Permitir la conexión"** → Siguiente
   - Marca todas las casillas (Dominio, Privada, Pública) → Siguiente
   - Nombre: `OpenProject` → Finalizar

## ✅ Verificar

Después de configurar el firewall, verifica que funciona:

```bash
# Desde otro dispositivo en la red, abre el navegador y ve a:
http://172.21.11.61:8082
```

## 🔒 Seguridad

- Esta regla solo permite acceso desde tu red local
- No expone OpenProject a Internet
- Es seguro para uso en red local

## 🗑️ Eliminar la regla (si es necesario)

```powershell
Remove-NetFirewallRule -DisplayName "OpenProject"
```
