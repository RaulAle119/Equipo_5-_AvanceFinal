import platform
import subprocess
import os
import json
import argparse

script_path = r"C:\Users\raulg\Documents\GitHub\Equipo_5-_AvanceFinal\PIA_PC"

# Función para ejecutar scripts de PowerShell
def run_powershell_script(script_name):
    script = os.path.join(script_path, script_name)
    if not os.path.isfile(script):
        print(f"El script {script_name} no existe.")
        return
    print("Ejecutando PowerShell:", script_name)
    try:
        subprocess.run(["powershell", "-ExecutionPolicy", "Bypass", "-File", script], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error al ejecutar el script de PowerShell: {e}")

# Función para ejecutar scripts de Bash
def run_bash_script(script_name):
    script = os.path.join(script_path, script_name)
    if not os.path.isfile(script):
        print(f"El script {script_name} no existe.")
        return
    print("Ejecutando Bash:", script_name)
    try:
        subprocess.run(["bash", script], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error al ejecutar el script de Bash: {e}")

# Función para imprimir servicios desde un archivo JSON
def print_services(data):
    print('Servicios:')
    for service in data.get('services', []):
        print(service.get('name', 'Nombre no especificado'))

# Función para imprimir uso del disco desde un archivo JSON
def print_disk_usage(data):
    print('Uso del Disco:')
    for service in data.get('services', []):
        print(f'{service.get("name", "Nombre no especificado")}:\t{service.get("disk usage", "Uso no especificado")}')

def analizar_sistema(script_name, data):
    sistema = platform.system()
    
    if sistema == "Windows":
        print("Estás usando Windows.")
        run_powershell_script(script_name)
    elif sistema == "Linux":
        print("Estás usando Linux.")
        run_bash_script(script_name)
    else:
        print(f"El sistema operativo detectado es: {sistema}")

if __name__ == "__main__":
    # Configuración de argparse
    parser = argparse.ArgumentParser(description='Ejecutar scripts y mostrar información del sistema.')
    parser.add_argument('script', type=str, help='Nombre del script a ejecutar (sin ruta completa).')
    
    # Argumentos para mostrar servicios y uso del disco
    parser.add_argument('-s', '--services', action='store_true', help='Mostrar servicios desde el archivo JSON.')
    parser.add_argument('-d', '--diskusage', action='store_true', help='Mostrar uso del disco desde el archivo JSON.')

    # Analizar los argumentos
    args = parser.parse_args()

    # Cargar datos JSON
    try:
        with open('services.json') as f:
            data = json.load(f)
    except FileNotFoundError:
        print("El archivo services.json no se encuentra.")
        data = {}
    except json.JSONDecodeError:
        print("Error al leer el archivo services.json: el archivo no tiene un formato JSON válido.")
        data = {}

    # Llamar a la función para analizar el sistema y ejecutar el script
    analizar_sistema(args.script, data)

    # Mostrar servicios o uso del disco según los argumentos proporcionados
    if args.services:
        print_services(data)
    
    if args.diskusage:
        print_disk_usage(data)