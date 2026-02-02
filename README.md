# OpenProject con Docker Compose

Configuración de OpenProject con PostgreSQL usando Docker Compose.

## 📋 Requisitos Previos

- Docker instalado
- Docker Compose instalado

## 🚀 Inicio Rápido

### 1. Crear el archivo `.env`

Copia el archivo de plantilla y personalízalo:

```bash
copy env.template .env
```

### 2. Configurar variables de entorno

Edita el archivo `.env` y configura:

- **POSTGRES_PASSWORD**: Cambia la contraseña de la base de datos
- **OPENPROJECT_SECRET_KEY_BASE**: Genera una clave secreta segura (mínimo 32 caracteres)
- **OPENPROJECT_ADMIN_USER**: Usuario administrador (por defecto: `admin`)
- **OPENPROJECT_ADMIN_PASSWORD**: Contraseña del administrador (¡cámbiala!)
- **OPENPROJECT_ADMIN_EMAIL**: Email del administrador

#### Generar clave secreta

**Opción 1: Usando PowerShell (Windows)**
```powershell
powershell -ExecutionPolicy Bypass -File generate-secret.ps1
```

**Opción 2: Usando OpenSSL**
```bash
openssl rand -hex 32
```

**Opción 3: Manualmente**
Crea una cadena aleatoria de al menos 32 caracteres.

### 3. Iniciar los contenedores

```bash
docker-compose up -d
```

### 4. Acceder a OpenProject

Abre tu navegador en: `http://localhost:8082`

#### 🔐 Credenciales de Acceso Inicial

**Primera vez (Instalación inicial):**
- OpenProject mostrará un asistente de configuración
- O puedes usar las credenciales configuradas en tu `.env`:
  - **Usuario**: `admin` (o el valor de `OPENPROJECT_ADMIN_USER`)
  - **Contraseña**: La que configuraste en `OPENPROJECT_ADMIN_PASSWORD`

**Si ya está configurado:**
- Usa las credenciales que creaste durante la primera configuración
- O las que están en tu archivo `.env`

## 🔧 Configuración

### Puertos

- **OpenProject**: `8082` (configurable con `OPENPROJECT_PORT`)
- **PostgreSQL**: No expuesto por defecto (solo accesible desde dentro de Docker)

### Exponer PostgreSQL (Opcional)

Si necesitas acceder a PostgreSQL desde fuera de Docker:

1. Descomenta la línea 14 en `docker-compose.yml`:
   ```yaml
   - "${POSTGRES_PORT:-5435}:5432"
   ```

2. Configura `POSTGRES_PORT` en tu `.env` (por defecto: `5435`)

### Variables de Entorno

Todas las variables están documentadas en `env.template`.

## 📊 Monitoreo

### Ver logs

```bash
# Todos los servicios
docker-compose logs -f

# Solo OpenProject
docker-compose logs -f openproject

# Solo PostgreSQL
docker-compose logs -f db
```

### Estado de los contenedores

```bash
docker-compose ps
```

## 🛑 Detener los contenedores

```bash
# Detener
docker-compose stop

# Detener y eliminar contenedores
docker-compose down

# Detener, eliminar contenedores y volúmenes (¡CUIDADO! Elimina datos)
docker-compose down -v
```

## 🔄 Reconstruir/Recrear Contenedores

### Después de cambiar configuración o variables de entorno:

```bash
# Recrear contenedores (recomendado)
docker-compose up -d --force-recreate

# O reiniciar (más rápido)
docker-compose restart
```

### Ver más comandos:
Consulta el archivo `COMANDOS.md` para una lista completa de comandos útiles.

## 🔒 Seguridad

- ✅ Las contraseñas están en el archivo `.env` (no versionado)
- ✅ PostgreSQL no está expuesto por defecto
- ✅ Red aislada para los servicios
- ✅ Health checks configurados
- ✅ Límites de recursos configurados

## 📝 Notas

- Los datos se persisten en volúmenes Docker
- El primer inicio puede tardar varios minutos
- Asegúrate de tener al menos 3GB de RAM disponible
