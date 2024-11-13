import platform
import subprocess
import os

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

def analizar_sistema():
    sistema = platform.system()
    
    if sistema == "Windows":
        print("Estás usando Windows.")
        run_powershell_script("main.ps1")
    elif sistema == "Linux":
        print("Estás usando Linux.")
        run_bash_script("main12.sh")
    else:
        print(f"El sistema operativo detectado es: {sistema}")

if __name__ == "__main__":
    analizar_sistema()
