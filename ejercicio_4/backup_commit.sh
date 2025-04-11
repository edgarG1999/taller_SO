#!/bin/bash

# Configuración
PROJECT_DIR="/home/edgar/Escritorio/proyecto"
BACKUP_DIR="/home/edgar/Escritorio/backup/proyecto"
LOG_FILE="/home/edgar/Escritorio/backup/proyecto.log"
GIT_REPO="git@github.com:edgarG1999/backup.git"

# Configurar Git si no está configurado
if [ -z "$(git config --global user.email)" ]; then
    git config --global user.email "ef.edgar1999@gmail.com"
    git config --global user.name "edgarG1999"
fi

# Crear directorios si no existen
mkdir -p "$BACKUP_DIR"
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

# Entrar al directorio
cd "$PROJECT_DIR" || { echo "Error: No se pudo acceder a $PROJECT_DIR" >> "$LOG_FILE"; exit 1; }

# Registrar inicio
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando proceso..." >> "$LOG_FILE"

# 1. Hacer backup
mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/backup_$(date +%Y%m%d%H%M%S).tar.gz" --absolute-names "$PROJECT_DIR" >> "$LOG_FILE" 2>&1

# 2. Actualizar repo git
# Agregar todos los cambios, incluyendo submodulos si existen
git add -A >> "$LOG_FILE" 2>&1

# Verificar si hay cambios para commit
if [ -n "$(git status --porcelain)" ]; then
    git commit -m "Auto-commit $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE" 2>&1
    
    # 3. Sincronizar cambios con el remoto
    eval "$(ssh-agent -s)" >> "$LOG_FILE" 2>&1
    ssh-add /home/edgar/.ssh/id_rsa >> "$LOG_FILE" 2>&1
    
    # Primero hacer pull con rebase para evitar conflictos
    git pull --rebase origin main >> "$LOG_FILE" 2>&1
    
    # Luego hacer push
    git push origin main >> "$LOG_FILE" 2>&1
else
    echo "No hay cambios para commit" >> "$LOG_FILE"
fi

# 4. Limpieza (opcional)
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete >> "$LOG_FILE" 2>&1

# Registrar finalización
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Proceso completado con estado: $?" >> "$LOG_FILE"