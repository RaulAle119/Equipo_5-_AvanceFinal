import platform
import subprocess
import time
import os

def ejecutar_script_powershell(ruta_script):
    try:
        # Verificar si el archivo existe
        if not os.path.isfile(ruta_script):
            print(f"El archivo {ruta_script} no existe.")
            return

        inicio = time.time()
        resultado = subprocess.run(
            ["powershell", "-ExecutionPolicy", "Bypass", "-File", ruta_script],
            check=True,
            capture_output=True,
            text=True,
            
        )
        fin = time.time()
        print(f"Resultado del script de PowerShell:\n{resultado.stdout}")
        print(f"Tiempo de ejecución: {fin - inicio:.2f} segundos")
    except subprocess.CalledProcessError as e:
        print(f"Error al ejecutar el script de PowerShell: {e}\nSalida de error:\n{e.stderr}\nSalida estándar:\n{e.stdout}")
    except subprocess.TimeoutExpired:
        print(f"El script de PowerShell superó el tiempo de espera de 60 segundos.")

def analizar_sistema():
    sistema = platform.system()
    
    if sistema == "Windows":
        print("Estás usando Windows.")
        ruta_script = r"C:\Users\raulg\Documents\GitHub\Equipo_5-_AvanceFinal\PIA_PC\main.ps1"
        ejecutar_script_powershell(ruta_script)
    elif sistema == "Linux":
        print("Estás usando Linux.")
    else:
        print(f"El sistema operativo detectado es: {sistema}")

if __name__ == "__main__":
    analizar_sistema()
