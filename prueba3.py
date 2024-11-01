import platform
import subprocess
import os

script_path = r"C:\Users\raulg\Documents\GitHub\Equipo_5-_AvanceFinal\PIA_PC\main.ps1"

# Funcon para ejecutar scripts de PowerShell
def run_powershell_script(script_name):
    script = os.path.join(script_path, script_name)
    subprocess.run(["powershell", "-ExecutionPolicy", "Bypass", "-File", script], check=True)

# Funcion para ejecutar scripts de Bash
def run_bash_script(script_name):
    script = os.path.join(script_path, script_name)
    subprocess.run(["bash", script], check=True)

def analizar_sistema():
    sistema = platform.system()
    
    if sistema == "Windows":
        print("Estás usando Windows.")
        ruta_script = r"C:\Users\raulg\Documents\GitHub\Equipo_5-_AvanceFinal\PIA_PC\main.ps1"
        run_powershell_script(ruta_script)
    elif sistema == "Linux":
        print("Estás usando Linux.")
        ruta_script = "main12.sh"  
        run_bash_script(ruta_script)
    else:
        print(f"El sistema operativo detectado es: {sistema}")

if __name__ == "__main__":
    analizar_sistema()
