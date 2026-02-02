# 🔧 Comandos para Reconstruir y Gestionar Contenedores

## 🔄 Reconstruir/Recrear Contenedores

### Opción 1: Recrear contenedores (Recomendado)
```bash
docker-compose up -d --force-recreate
```
- Recrea los contenedores aunque no haya cambios
- Mantiene los volúmenes (no pierdes datos)
- Útil cuando cambias variables de entorno

### Opción 2: Recrear y reconstruir
```bash
docker-compose up -d --build --force-recreate
```
- Reconstruye las imágenes si tienes Dockerfile
- Recrea los contenedores
- En tu caso (usando imágenes pre-construidas), no es necesario el `--build`

### Opción 3: Detener, eliminar y volver a crear
```bash
docker-compose down
docker-compose up -d
```
- Detiene y elimina los contenedores
- Los vuelve a crear con la configuración actual
- **Mantiene los volúmenes** (no pierdes datos)

## 🔄 Reiniciar Contenedores

### Reiniciar todos los servicios
```bash
docker-compose restart
```

### Reiniciar un servicio específico
```bash
# Reiniciar solo OpenProject
docker-compose restart openproject

# Reiniciar solo la base de datos
docker-compose restart db
```

## 📥 Actualizar Imágenes

### Actualizar todas las imágenes
```bash
docker-compose pull
docker-compose up -d
```

### Actualizar una imagen específica
```bash
docker pull openproject/openproject:14
docker-compose up -d openproject
```

## 🗑️ Eliminar y Recrear (CUIDADO)

### Eliminar contenedores y volúmenes (¡PIERDES DATOS!)
```bash
docker-compose down -v
docker-compose up -d
```
⚠️ **ADVERTENCIA**: Esto elimina TODOS los datos (base de datos y archivos de OpenProject)

### Eliminar solo contenedores (mantiene datos)
```bash
docker-compose down
docker-compose up -d
```

## 🔍 Ver Estado y Logs

### Ver estado de los contenedores
```bash
docker-compose ps
```

### Ver logs en tiempo real
```bash
# Todos los servicios
docker-compose logs -f

# Solo OpenProject
docker-compose logs -f openproject

# Solo base de datos
docker-compose logs -f db
```

### Ver últimas líneas de logs
```bash
docker-compose logs --tail=100 openproject
```

## 🔄 Después de Cambiar Variables de Entorno

Si modificaste el archivo `.env`:

1. **Recrear contenedores** (recomendado):
   ```bash
   docker-compose up -d --force-recreate
   ```

2. O **reiniciar** (más rápido, pero puede no aplicar todos los cambios):
   ```bash
   docker-compose restart
   ```

## 📋 Comandos Útiles Adicionales

### Ver qué imágenes están usando
```bash
docker-compose images
```

### Ver uso de recursos
```bash
docker stats
```

### Ejecutar comandos dentro de un contenedor
```bash
# Entrar al contenedor de OpenProject
docker exec -it openproject bash

# Entrar al contenedor de PostgreSQL
docker exec -it openproject-db psql -U openproject -d openproject
```

### Limpiar recursos no usados
```bash
# Eliminar imágenes no usadas
docker image prune

# Eliminar contenedores detenidos
docker container prune

# Limpieza completa (¡CUIDADO!)
docker system prune -a
```

## 🚀 Flujo Recomendado para Cambios

1. **Edita** `docker-compose.yml` o `.env`
2. **Recrea** los contenedores:
   ```bash
   docker-compose up -d --force-recreate
   ```
3. **Verifica** que todo funcione:
   ```bash
   docker-compose ps
   docker-compose logs -f
   ```

## ⚡ Comandos Rápidos

```bash
# Reiniciar todo
docker-compose restart

# Recrear con nueva configuración
docker-compose up -d --force-recreate

# Ver logs
docker-compose logs -f

# Detener todo
docker-compose stop

# Iniciar todo
docker-compose start
```
