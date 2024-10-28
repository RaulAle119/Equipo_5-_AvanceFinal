import requests
import logging

logging.basicConfig(
    filename='log.txt',
    level=logging.ERROR,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

API_KEY = input("Ingresa tu clave de API: ")
BASE_URL = 'https://api.abuseipdb.com/api/v2/'

CATEGORIAS = [
    "Spam",
    "Hacking",
    "Malware",
    "Phishing",
    "DDoS",
    "Botnet",
    "Fraud",
    "Other"
]

def check_ip(ip_address):
    url = f'{BASE_URL}check'
    headers = {
        'Accept': 'application/json',
        'Key': API_KEY
    }
    params = {
        'ipAddress': ip_address,
        'maxAgeInDays': '90'
    }
    
    try:
        respuesta = requests.get(url, headers=headers, params=params)
        respuesta.raise_for_status()  #Respuesta mala
        resultado = respuesta.json()
        
        #Formato
        print("\n--- Resultado de la Verificación de IP ---")
        print(f"IP: {resultado.get('data', {}).get('ipAddress', 'No disponible')}")
        print(f"Confianza en abuso: {resultado.get('data', {}).get('abuseConfidenceScore', 'No disponible')}%")
        print(f"Total de reportes: {resultado.get('data', {}).get('totalReports', 'No disponible')}")
        
        if 'reports' in resultado['data']:
            print("\nDetalles de los reportes:")
            for reporte in resultado['data']['reports']:
                print(f"- Fecha: {reporte['date']} | Comentario: {reporte['comment']} | Categoría: {reporte['category']}")
        
    except requests.exceptions.HTTPError as e:
        error_message = f"Error HTTP: {e}"
        print(error_message)
        logging.error(error_message)  # Guardar error en el log
    except Exception as e:
        error_message = f"Ocurrió un error: {e}"
        print(error_message)
        logging.error(error_message)  # Guardar error en el log

def report_ip(ip_address, comentario, categorias):
    """Reporta una IP abusiva."""
    url = f'{BASE_URL}report'
    headers = {
        'Accept': 'application/json',
        'Key': API_KEY
    }
    datos = {
        'ip': ip_address,
        'comment': comentario,
        'categories': categorias.split(',')  #Lista
    }
    
    try:
        respuesta = requests.post(url, headers=headers, json=datos)
        respuesta.raise_for_status()
        return respuesta.json()
    except requests.exceptions.HTTPError as e:
        error_message = f"Error HTTP: {e}"
        print(error_message)
        logging.error(error_message)
    except Exception as e:
        error_message = f"Ocurrió un error: {e}"
        print(error_message)
        logging.error(error_message)

def print_error_log():
    try:
        with open('log.txt', 'r') as log_file:
            logs = log_file.read()
            if logs:
                print("\n--- Mensajes de Error Registrados ---")
                print(logs)
            else:
                print("No hay mensajes de error.")
    except FileNotFoundError:
        print("El archivo de log no existe.")

def menu_data():
    
    while True:
        print("\nMenú:")
        print("1. Verificar IP")
        print("2. Reportar IP")
        print("3. Imprimir errores registrados")
        print("4. Salir")
        
        opcion = input("Selecciona una opción (1-4): ")
        
        if opcion == '1':
            ip_address = input("Ingresa la dirección IP a verificar: ")
            check_ip(ip_address)
            
        elif opcion == '2':
            ip_address = input("Ingresa la dirección IP a reportar: ")
            comentario = input("Ingresa un comentario para el reporte: ")
            
            print("\nCategorías disponibles:")
            for index, categoria in enumerate(CATEGORIAS, start=1):
                print(f"{index}. {categoria}")
                
            categorias_seleccionadas = input("Selecciona las categorías (separadas por comas usando los números): ")
            categorias_indices = [int(i.strip()) - 1 for i in categorias_seleccionadas.split(',')]
            categorias_finales = [CATEGORIAS[i] for i in categorias_indices if 0 <= i < len(CATEGORIAS)]
            
            resultado = report_ip(ip_address, comentario, ','.join(categorias_finales))
            if resultado:
                print(resultado)
        
        elif opcion == '3':
            print_error_log()
            
        elif opcion == '4':
            confirmar_salida = input("¿Estás seguro de que deseas salir? (y/n): ").lower()
            if confirmar_salida == 'y':
                print("Saliendo...")
                break
            elif confirmar_salida == 'n':
                print("Regresando al menú principal...")
            else:
                print("Opción inválida. Responde con 'y' o 'n'.")
        
        else:
            print("Opción inválida. Intenta de nuevo.")

if __name__ == "__main__":
    menu_data()