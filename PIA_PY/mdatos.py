import os
import logging
from mutagen import File

# Configuracion de logging para guardar los errores en un archivo
logging.basicConfig(
    filename='errores_metadatos.log',
    level=logging.ERROR,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

def mostrar_metadatos(ruta_archivo):
    try:
        audio = File(ruta_archivo)
        if audio is not None:
            print(f"\nMetadatos de {ruta_archivo}:")
            for clave, valor in audio.items():
                print(f"{clave}: {valor}")
        else:
            raise ValueError(f"No se pudieron leer los metadatos de {ruta_archivo}")
    except Exception as e:
        error_message = f"Error al leer {ruta_archivo}: {str(e)}"
        print(error_message)
        logging.error(error_message)  

def listar_archivos(ruta_directorio, extensiones):
    try:
        archivos_encontrados = []
        for archivo in os.listdir(ruta_directorio):
            if archivo.endswith(extensiones):
                archivos_encontrados.append(archivo)
        return archivos_encontrados
    except Exception as e:
        error_message = f"Error al listar archivos en {ruta_directorio}: {str(e)}"
        print(error_message)
        logging.error(error_message)
        return []

def imprimir_errores():
    try:
        with open('errores_metadatos.log', 'r') as log_file:
            logs = log_file.read()
            if logs:
                print("\n--- Errores registrados ---")
                print(logs)
            else:
                print("No hay errores registrados.")
    except FileNotFoundError:
        print("El archivo de log no existe.")
    except Exception as e:
        print(f"Error al leer el archivo de log: {e}")

def menu_meta():
    while True:
        print("\n--- Menú ---")
        print("1. Mostrar metadatos de archivos .mp3")
        print("2. Mostrar metadatos de archivos .flac")
        print("3. Mostrar metadatos de archivos .ogg")
        print("4. Mostrar metadatos de archivos .wav")
        print("5. Mostrar metadatos de archivos .mp4")
        print("6. Mostrar metadatos de archivos .JPG")
        print("7. Mostrar metadatos de todos los archivos")
        print("8. Mostrar errores registrados")
        print("9. Salir")
        
        opcion = input("Selecciona una opción: ")

        if opcion in ['1', '2', '3', '4', '5', '6', '7']:
            ruta_directorio = input("Introduce la ruta del directorio: ")
           
            if os.path.isdir(ruta_directorio):
                extensiones = {
                    '1': ('.mp3',),
                    '2': ('.flac',),
                    '3': ('.ogg',),
                    '4': ('.wav',),
                    '5': ('.mp4',),
                    '6': ('.JPG',),
                    '7': ('.mp3', '.flac', '.ogg', '.wav', '.mp4', '.JPG')
                }
                archivos = listar_archivos(ruta_directorio, extensiones[opcion])
                if archivos:
                    for archivo in archivos:
                        ruta_archivo = os.path.join(ruta_directorio, archivo)
                        mostrar_metadatos(ruta_archivo)
                else:
                    print("No se encontraron archivos en el directorio.")
            else:
               
                error_message = f"Ruta no válida: {ruta_directorio}"
                print(error_message)
                logging.error(error_message)
        elif opcion == '8':
            imprimir_errores()
        
        elif opcion == '9':
            print("Saliendo del programa.")
            break
        
        else:
            print("Opción no válida. Por favor, selecciona una opción válida.")

if __name__ == "__main__":
    menu_meta()
