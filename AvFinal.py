import platform
import subprocess

def importar_modulo_powershell(modulo):
    try:
        # Ejecutar comando de PowerShell para importar el módulo
        comando = "Import-Module 'C:\\Users\\raulg\\Documents\\GitHub\\Equipo_5-_AvanceFinal\\Show-Resources.psm1'"

        subprocess.run(["powershell", "-Command", comando], check=True)
        print(f"Modulo '{modulo}' importado correctamente.")
    except subprocess.CalledProcessError as e:
        print(f"Error al importar el modulo '{modulo}': {e}")

def analyze_system():
    system = platform.system()

    if system == "Windows":
        print("Estas en Windows")
        importar_modulo_powershell('Show-Resources')
    elif system == "Linux":
        print("Estas en Linux")
    else:
        print(f"El sistema operativo es: {system}")

if __name__ == "__main__":
    analyze_system()
