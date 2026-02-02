# 🔧 Solución de Problemas - OpenProject

## ❌ Problema: "503 Service Unavailable" o no carga la página

### Síntomas
- El contenedor está corriendo pero muestra "unhealthy"
- Al acceder a `http://localhost:8082` no carga o muestra error 503
- Los logs muestran "Booting Puma" o "Rails application starting"

### Solución

**OpenProject está iniciando** - esto es normal, especialmente en la primera instalación.

#### 1. Espera unos minutos
OpenProject puede tardar **3-5 minutos** en iniciarse completamente, especialmente en la primera instalación.

#### 2. Verifica el estado
```bash
docker-compose logs -f openproject
```

Busca mensajes como:
- ✅ `=> Rails application starting` - Está iniciando
- ✅ `Listening on tcp://0.0.0.0:3000` - Ya está listo
- ❌ Errores de base de datos - Problema de conexión

#### 3. Verifica que la base de datos esté lista
```bash
docker-compose ps
```

La base de datos debe mostrar `(healthy)`. Si no:
```bash
docker-compose restart db
docker-compose restart openproject
```

#### 4. Revisa los logs completos
```bash
docker-compose logs --tail=200 openproject
```

## ❌ Problema: Error de conexión a la base de datos

### Síntomas
- Logs muestran "could not connect to server" o "database does not exist"
- El contenedor se reinicia constantemente

### Solución

1. **Verifica las variables de entorno en `.env`**:
   ```env
   POSTGRES_DB=openproject
   POSTGRES_USER=openproject
   POSTGRES_PASSWORD=tu_contraseña
   ```

2. **Verifica que la BD esté corriendo**:
   ```bash
   docker-compose ps db
   ```

3. **Reinicia ambos servicios**:
   ```bash
   docker-compose restart db
   sleep 10
   docker-compose restart openproject
   ```

## ❌ Problema: Puerto ya en uso

### Síntomas
- Error: "port is already allocated" o "address already in use"

### Solución

1. **Cambia el puerto en `.env`**:
   ```env
   OPENPROJECT_PORT=8083
   ```

2. **Actualiza el hostname**:
   ```env
   OPENPROJECT_HOST__NAME=localhost:8083
   ```

3. **Recrea los contenedores**:
   ```bash
   docker-compose up -d --force-recreate
   ```

## ❌ Problema: Contenedor se reinicia constantemente

### Solución

1. **Revisa los logs**:
   ```bash
   docker-compose logs --tail=100 openproject
   ```

2. **Verifica recursos del sistema**:
   ```bash
   docker stats
   ```
   Asegúrate de tener al menos 3GB de RAM disponible.

3. **Aumenta el tiempo de inicio**:
   El `start_period` en el healthcheck ya está configurado a 180 segundos.

## ❌ Problema: No puedo iniciar sesión

### Solución

**Primera instalación:**
- Usuario: `admin`
- Contraseña: `admin`

**Si ya configuraste un usuario:**
- Usa las credenciales que configuraste en `.env`:
  ```env
  OPENPROJECT_ADMIN_USER=admin
  OPENPROJECT_ADMIN_PASSWORD=tu_contraseña
  ```

**Si olvidaste la contraseña:**
```bash
docker exec -it openproject bundle exec rails runner "user = User.find_by(login: 'admin'); user.password = 'nueva_contraseña'; user.password_confirmation = 'nueva_contraseña'; user.save!"
```

## ✅ Verificar que todo funciona

### 1. Estado de contenedores
```bash
docker-compose ps
```
Ambos deben estar `Up` y la BD debe estar `(healthy)`.

### 2. Probar conexión
```bash
# Desde dentro del contenedor
docker exec openproject curl -I http://localhost:80

# Debe responder con HTTP 200 o 302 (redirect)
```

### 3. Acceder desde el navegador
- Abre: `http://localhost:8082` (o el puerto que configuraste)
- Debe cargar la página de OpenProject

## 📊 Comandos de diagnóstico

```bash
# Ver estado
docker-compose ps

# Ver logs en tiempo real
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f openproject
docker-compose logs -f db

# Ver uso de recursos
docker stats

# Verificar puertos
netstat -an | findstr :8082

# Probar conexión interna
docker exec openproject curl http://localhost:80
```

## 🔄 Reiniciar todo desde cero

Si nada funciona:

```bash
# 1. Detener todo
docker-compose down

# 2. Verificar que no hay contenedores
docker ps -a | findstr openproject

# 3. Si quieres empezar completamente de nuevo (¡PIERDES DATOS!)
docker-compose down -v

# 4. Volver a iniciar
docker-compose up -d

# 5. Ver logs
docker-compose logs -f
```

## 📝 Notas importantes

- **Primera instalación**: Puede tardar 5-10 minutos
- **Memoria**: Necesitas al menos 3GB de RAM libre
- **Disco**: Asegúrate de tener espacio suficiente
- **Puertos**: Verifica que no estén ocupados por otros servicios
