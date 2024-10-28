import random
import string
import logging

# Configurar el registro de errores
logging.basicConfig(filename='errores.log', level=logging.ERROR, 
                    format='%(asctime)s:%(levelname)s:%(message)s')

# Lista para almacenar errores durante la ejecución
errores = []

def generar_contraseña(longitud=12):
    """
    Genera una contraseña aleatoria y segura con los siguientes requisitos:
    - Longitud mínima de 8 caracteres.
    - Incluir mayúsculas, minúsculas, números y caracteres especiales.
    """
    # Validar la longitud mínima
    if longitud < 8:
        mensaje_error = "La longitud mínima de la contraseña es 8 caracteres."
        logging.error(mensaje_error)
        errores.append(mensaje_error)
        raise ValueError(mensaje_error)
    
    # Definir los tipos de caracteres que debe tener la contraseña
    caracteres = string.ascii_letters + string.digits + string.punctuation
    
    # Generar la contraseña combinando aleatoriamente los caracteres
    contraseña = ''.join(random.choice(caracteres) for _ in range(longitud))
    
    return contraseña

def main_contraseña():
    """
    Función principal para interactuar con el usuario.
    Pide la longitud de la contraseña y genera una contraseña segura.
    """
    while True:
        try:
            # Solicitar al usuario la longitud de la contraseña
            longitud = int(input("Ingrese la longitud de la contraseña (mínimo 8): "))
            
            # Generar la contraseña
            contraseña = generar_contraseña(longitud)
            
            # Mostrar la contraseña generada
            print("Contraseña generada:", contraseña)
            break  # Salir del bucle después de generar la contraseña
            
        except ValueError as e:
            print(f"Error: {e}. Inténtelo de nuevo.")
        except Exception as e:
            logging.error(f"Error inesperado: {e}.")
            print(f"Error inesperado: {e}. Inténtelo de nuevo.")
    
    # Imprimir errores al final de la ejecución
    if errores:
        print("\nErrores registrados durante la ejecución:")
        for error in errores:
            print(error)

if __name__ == "__main__":
    main_contraseña()
