#!/bin/bash

PYTHON_SCRIPT="/home/edgar/Escritorio/taller_SO/ejercicio_2/graficaMonitor.py"
LOG_FILE="/home/edgar/Escritorio/var/log/monitor_recursos.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
MEMORY_USAGE=$(free -m | awk '/Mem:/ {printf "%.2f", $3/$2*100}')

echo "$TIMESTAMP - CPU: $CPU_USAGE% - Memoria: $MEMORY_USAGE%" >> $LOG_FILE

#crea la imagen de la grafica para que acompañe al archivo log
LINE_COUNT=$(wc -l < "$LOG_FILE")
python3 "$PYTHON_SCRIPT" 

 