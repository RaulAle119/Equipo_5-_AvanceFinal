import platform
import subprocess

def importMod_PS(modulo):
    try:
        # Ejecutar comando de PowerShell para importar el módulo
        comando = "Import-Module 'C:\\Users\\raulg\\Documents\\GitHub\\Equipo_5-_AvanceFinal\\Show-Resources.psm1'"

        subprocess.run(["powershell", "-Command", comando], check=True)
        print(f"Modulo '{modulo}' importado correctamente.")
    except subprocess.CalledProcessError as e:
        print(f"Error al importar el modulo '{modulo}': {e}")

def execFun_PS(funcion):
    try:
        comando_ejecutar = f"{funcion}"
        resultado = subprocess.run(["powershell", "-Command", comando_ejecutar], check=True, capture_output=True, text=True)
        print(f"Resultado de la función '{funcion}':\n{resultado.stdout}")
    except subprocess.CalledProcessError as e:
        print(f"Error al ejecutar la función '{funcion}': {e}")

def analyze_system():
    system = platform.system()

    if system == "Windows":
        print("Estas en Windows")
        importMod_PS('Show-Resources')
        ruta_modulo = r"C:\\Users\\raulg\\Documents\\GitHub\\Equipo_5-_AvanceFinal\\Show-Resources.psm1"
        importMod_PS(ruta_modulo)
        execFun_PS("Show_Resources")  

    elif system == "Linux":
        print("Estas en Linux")
    else:
        print(f"El sistema operativo es: {system}")

if __name__ == "__main__":
    analyze_system()
