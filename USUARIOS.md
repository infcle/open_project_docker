# 👥 Gestión de Usuarios en OpenProject

## 🔐 Usuario Administrador Inicial

### Configuración en el archivo `.env`

El usuario administrador inicial se configura mediante estas variables de entorno:

```env
OPENPROJECT_ADMIN_USER=admin
OPENPROJECT_ADMIN_PASSWORD=TuContrasenaSegura123!
OPENPROJECT_ADMIN_EMAIL=admin@tudominio.com
```

### ⚠️ Importante

- Estas credenciales **solo se usan en la primera instalación**
- Si OpenProject ya está configurado, estas variables serán **ignoradas**
- Después de la primera configuración, debes usar las credenciales que creaste

## 🚀 Primer Acceso

### Opción 1: Asistente de Configuración

1. Accede a `http://localhost:8082` (o el puerto que configuraste)
2. OpenProject mostrará un asistente de configuración inicial
3. Sigue los pasos para crear tu usuario administrador

### Opción 2: Usar Variables de Entorno

Si configuraste las variables en tu `.env`, puedes usar:
- **Usuario**: El valor de `OPENPROJECT_ADMIN_USER` (por defecto: `admin`)
- **Contraseña**: El valor de `OPENPROJECT_ADMIN_PASSWORD`

## 📋 Usuarios de la Base de Datos

### PostgreSQL

Las credenciales para acceder directamente a PostgreSQL están en tu `.env`:

```env
POSTGRES_USER=openproject
POSTGRES_PASSWORD=TuContrasenaBD123!
POSTGRES_DB=openproject
```

**Acceso desde fuera de Docker:**
- **Host**: `localhost`
- **Puerto**: `5435` (o el valor de `POSTGRES_PORT` en tu `.env`)
- **Usuario**: Valor de `POSTGRES_USER`
- **Contraseña**: Valor de `POSTGRES_PASSWORD`
- **Base de datos**: Valor de `POSTGRES_DB`

## 🔍 Verificar Usuarios Existentes

### Desde la interfaz web de OpenProject

1. Inicia sesión como administrador
2. Ve a **Administración** → **Usuarios**
3. Verás la lista de todos los usuarios

### Desde la base de datos (PostgreSQL)

```bash
# Conectarte a PostgreSQL
docker exec -it openproject-db psql -U openproject -d openproject

# Ver usuarios
SELECT login, firstname, lastname, email, admin FROM users;
```

## ➕ Crear Nuevos Usuarios

### Desde la interfaz web

1. Inicia sesión como administrador
2. Ve a **Administración** → **Usuarios** → **Nuevo usuario**
3. Completa el formulario y asigna permisos

### Desde la línea de comandos (avanzado)

```bash
# Ejecutar comandos de OpenProject
docker exec -it openproject bundle exec rails runner "User.create!(login: 'nuevo_usuario', email: 'usuario@ejemplo.com', password: 'contraseña', admin: false)"
```

## 🔒 Seguridad

1. **Cambia las contraseñas por defecto** inmediatamente después de la instalación
2. **No uses contraseñas débiles** en producción
3. **Mantén el archivo `.env` seguro** y nunca lo subas a Git
4. **Revisa los permisos** de los usuarios regularmente
5. **Desactiva usuarios** que ya no necesiten acceso

## 📝 Notas

- El usuario `admin` es el administrador principal
- Puedes crear múltiples usuarios administradores desde la interfaz web
- Los usuarios pueden tener diferentes roles y permisos
- Los cambios en `.env` para usuarios admin solo afectan la primera instalación
