import matplotlib.pyplot as plt
import pandas as pd
from datetime import datetime

LOG_FILE = "/home/edgar/Escritorio/var/log/monitor_recursos.log"

timestamps = []
cpu_usage = []
mem_usage = []

with open(LOG_FILE, 'r') as file:
    for line in file:
        if "CPU" in line and "Memoria" in line:
            timestamp_str = line.split(" - ")[0]
            timestamp = datetime.strptime(timestamp_str, "%Y-%m-%d %H:%M:%S")
            timestamps.append(timestamp)
            
            # CPU
            cpu_str = line.split("CPU: ")[1].split("%")[0].strip()
            cpu_str = cpu_str.replace(',', '.')  
            cpu_usage.append(float(cpu_str))
            
            # MEMORIA
            mem_str = line.split("Memoria: ")[1].split("%")[0].strip()
            mem_str = mem_str.replace(',', '.')  
            mem_usage.append(float(mem_str))

# cuadritos de datos
data = pd.DataFrame({
    'Timestamp': timestamps,
    'CPU (%)': cpu_usage,
    'Memoria (%)': mem_usage
})

# Graficar
plt.figure(figsize=(12, 6))

# Gráfico de CPU
plt.subplot(2, 1, 1)
plt.plot(data['Timestamp'], data['CPU (%)'], color='red', label='CPU (%)')
plt.title('Monitor de Recursos - Uso de CPU y Memoria')
plt.ylabel('Uso de CPU (%)')
plt.grid(True)
plt.legend()

# Gráfico de Memoria
plt.subplot(2, 1, 2)
plt.plot(data['Timestamp'], data['Memoria (%)'], color='blue', label='Memoria (%)')
plt.xlabel('Tiempo')
plt.ylabel('Uso de Memoria (%)')
plt.grid(True)
plt.legend()

plt.tight_layout()

# Guardado
plt.savefig('/home/edgar/Escritorio/var/log/monitor_recursos.png')
print("Gráfico guardado como '/home/edgar/Escritorio/var/log/monitor_recursos.png'")