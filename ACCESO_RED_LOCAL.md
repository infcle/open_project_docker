# 🌐 Acceso desde la Red Local

Guía para configurar OpenProject para que sea accesible desde otros dispositivos en tu red local.

## 📋 Pasos para Configurar

### 1. Encontrar tu IP Local

Ejecuta en PowerShell o CMD:
```bash
ipconfig | findstr IPv4
```

Busca la IP que empieza con `192.168.x.x` o `172.x.x.x` (no la que dice `172.18.x.x` o `172.30.x.x` que son de Docker).

**Ejemplo de salida:**
```
Dirección IPv4. . . . . . . . . . . . . . : 192.168.1.100
```

### 2. Configurar el archivo `.env`

Edita tu archivo `.env` y cambia:

```env
# Reemplaza con TU IP local
OPENPROJECT_HOST__NAME=192.168.1.100:8082
```

**Importante:** Usa la IP de tu máquina, NO `localhost`.

### 3. Configurar el Firewall de Windows

Necesitas permitir el puerto 8082 en el firewall:

#### Opción A: Desde PowerShell (como Administrador)

```powershell
New-NetFirewallRule -DisplayName "OpenProject" -Direction Inbound -LocalPort 8082 -Protocol TCP -Action Allow
```

#### Opción B: Desde la Interfaz Gráfica

1. Abre **Windows Defender Firewall**
2. Click en **Configuración avanzada**
3. Click en **Reglas de entrada** → **Nueva regla**
4. Selecciona **Puerto** → Siguiente
5. Selecciona **TCP** y escribe `8082` → Siguiente
6. Selecciona **Permitir la conexión** → Siguiente
7. Marca todas las opciones → Siguiente
8. Nombre: `OpenProject` → Finalizar

### 4. Recrear los Contenedores

Después de cambiar el `.env`:

```bash
cd E:\Contenedores\open_project
docker-compose down
docker-compose up -d
```

O simplemente:

```bash
docker-compose up -d --force-recreate
```

## 🔗 Acceso

### Desde tu máquina:
```
http://localhost:8082
```

### Desde otros dispositivos en la red local:
```
http://TU_IP_LOCAL:8082
```

**Ejemplo:**
```
http://192.168.1.100:8082
```

## ✅ Verificar que Funciona

### 1. Desde tu máquina:
```bash
curl http://localhost:8082
```

### 2. Desde otro dispositivo en la red:
- Abre un navegador
- Ve a `http://TU_IP:8082`
- Debe cargar OpenProject

### 3. Verificar que el puerto está abierto:
```bash
netstat -an | findstr :8082
```

Debe mostrar:
```
TCP    0.0.0.0:8082           0.0.0.0:0              LISTENING
```

## 🔒 Seguridad

### Recomendaciones:

1. **Solo en red local**: Esta configuración expone OpenProject solo en tu red local, no en Internet.

2. **Cambiar contraseñas por defecto**:
   - Usuario admin: Cambia la contraseña inmediatamente
   - Base de datos: Usa contraseñas seguras en `.env`

3. **Si quieres acceso desde Internet** (NO recomendado sin HTTPS):
   - Necesitas configurar tu router (port forwarding)
   - **IMPORTANTE**: Usa HTTPS con certificado SSL
   - Considera usar un proxy reverso (nginx, traefik)

4. **Firewall del Router**:
   - Por defecto, tu router bloquea conexiones entrantes
   - Esto es bueno para seguridad
   - Solo dispositivos en tu red local podrán acceder

## 🐛 Solución de Problemas

### No puedo acceder desde otro dispositivo

1. **Verifica la IP**:
   ```bash
   ipconfig
   ```
   Asegúrate de usar la IP correcta.

2. **Verifica el firewall**:
   ```powershell
   Get-NetFirewallRule -DisplayName "OpenProject"
   ```

3. **Verifica que Docker esté escuchando en todas las interfaces**:
   ```bash
   netstat -an | findstr :8082
   ```
   Debe mostrar `0.0.0.0:8082`, no solo `127.0.0.1:8082`.

4. **Reinicia los contenedores**:
   ```bash
   docker-compose restart
   ```

### El puerto está ocupado

Si el puerto 8082 está ocupado, cambia el puerto en `.env`:

```env
OPENPROJECT_PORT=8083
OPENPROJECT_HOST__NAME=TU_IP:8083
```

Luego recrea los contenedores.

### Error de conexión

1. Verifica que ambos dispositivos estén en la misma red
2. Verifica que el firewall permita el puerto
3. Prueba hacer ping desde el otro dispositivo:
   ```bash
   ping TU_IP
   ```

## 📝 Notas

- **IP Dinámica**: Si tu IP cambia (DHCP), tendrás que actualizar `OPENPROJECT_HOST__NAME`
- **Nombre de host**: Puedes usar un nombre de host si configuras DNS local (avanzado)
- **HTTPS**: Para producción, considera configurar HTTPS con Let's Encrypt

## 🔄 Actualizar la IP

Si tu IP cambia:

1. Encuentra la nueva IP: `ipconfig | findstr IPv4`
2. Actualiza `.env`: `OPENPROJECT_HOST__NAME=NUEVA_IP:8082`
3. Recrea contenedores: `docker-compose up -d --force-recreate`
