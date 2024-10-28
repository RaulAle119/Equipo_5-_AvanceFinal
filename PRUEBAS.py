import platform
import subprocess

def importar_modulo_powershell(ruta_modulo):
    try:
        comando_importar = f"Import-Module '{ruta_modulo}'"
        subprocess.run(["powershell", "-Command", comando_importar], check=True)
        print(f"Módulo '{ruta_modulo}' importado correctamente.")

        # Verifica las funciones del módulo importado
        resultado = subprocess.run(["powershell", "-Command", "Get-Command -Module Arch_Oc"], check=True, capture_output=True, text=True)
        print(f"Funciones disponibles en el módulo:\n{resultado.stdout}")
    except subprocess.CalledProcessError as e:
        print(f"Error al importar el módulo '{ruta_modulo}': {e}")

def ejecutar_funcion_powershell(funcion):
    try:
        # Ejecuta la función sin encapsularla en comillas innecesarias
        resultado = subprocess.run(["powershell", "-Command", funcion], check=True, capture_output=True, text=True)
        print(f"Resultado de la función '{funcion}':\n{resultado.stdout}")
    except subprocess.CalledProcessError as e:
        print(f"Error al ejecutar la función '{funcion}': {e}\nSalida de error:\n{e.stderr}")

def analizar_sistema():
    sistema = platform.system()
    
    if sistema == "Windows":
        print("Estás usando Windows.")
        ruta_modulo = r"C:\\Users\\raulg\\Documents\\GitHub\\Equipo_5-_AvanceFinal\\Arch_Oc.psm1"
        importar_modulo_powershell(ruta_modulo)
        
        # Llama a la función correcta
        ejecutar_funcion_powershell('archivos_ocultos')  # Asegúrate de que este sea el nombre correcto
    elif sistema == "Linux":
        print("Estás usando Linux.")
    else:
        print(f"El sistema operativo detectado es: {sistema}")

if __name__ == "__main__":
    analizar_sistema()
