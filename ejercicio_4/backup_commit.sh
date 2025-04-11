#!/bin/bash

# Configuración
PROJECT_DIR="/home/edgar/Escritorio/taller_SO/ejercicio_4"
BACKUP_DIR="/home/edgar/Escritorio/taller_SO/ejercicio_4/backup"
LOG_FILE="/home/edgar/Escritorio/taller_SO/ejercicio_4/backup/proyecto.log"
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
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando proceso de backup y commit..." >> "$LOG_FILE"

# 1. Crear backup del proyecto
BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y%m%d%H%M%S).tar.gz"
tar -czf "$BACKUP_FILE" --absolute-names "$PROJECT_DIR" >> "$LOG_FILE" 2>&1
if [ $? -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup creado: $BACKUP_FILE" >> "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error al crear el backup" >> "$LOG_FILE"
fi

# 2. Sincronizar con Git
git add -A >> "$LOG_FILE" 2>&1

if [ -n "$(git status --porcelain)" ]; then
    # Commit de los cambios
    git commit -m "Auto-commit $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE" 2>&1

    # Autenticación SSH (asegúrate de que la clave esté configurada)
    eval "$(ssh-agent -s)" >> "$LOG_FILE" 2>&1
    ssh-add /home/edgar/.ssh/id_ed25519 >> "$LOG_FILE" 2>&1

    # Sincronizar con el remoto (pull + push)
    git stash >> "$LOG_FILE" 2>&1
    git pull --rebase origin master >> "$LOG_FILE" 2>&1
    git push origin master >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cambios sincronizados con GitHub" >> "$LOG_FILE"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error al sincronizar con GitHub" >> "$LOG_FILE"
    fi
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] No hay cambios para commit" >> "$LOG_FILE"
fi

# 3. Limpieza: eliminar backups antiguos (>7 días)
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete >> "$LOG_FILE" 2>&1

# Registrar finalización
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Proceso completado. Estado: $?" >> "$LOG_FILE"
