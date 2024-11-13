import platform
import subprocess
import os
import hashlib
import os

def hash_propio():
    archivo_actual = __file__ 
    mihash = hashlib.sha256()

    with open(archivo_actual, "rb") as f:
        for bloque in iter(lambda: f.read(4096), b""):
            mihash.update(bloque)

    # Guarda el hash en un archivo txt
    with open("hash_arch.txt", "w") as f:
        f.write(f"Hash SHA-256 del archivo '{archivo_actual}': {mihash.hexdigest()}\n")
    print("Se guardo el hash en hash_arch.txt")

# Llamada a la función
hash_propio()
script_path = r"C:\Users\raulg\Desktop\AV_FINAL\PIA_PS"

# Funcion para ejecutar scripts de PowerShell
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
        print("Estas usando Windows.")
        run_powershell_script("main.ps1")
    elif sistema == "Linux":
        print("Estas usando Linux.")
        run_bash_script("main12.sh")
    else:
        print(f"El sistema operativo detectado es: {sistema}")

if __name__ == "__main__":
    analizar_sistema()
