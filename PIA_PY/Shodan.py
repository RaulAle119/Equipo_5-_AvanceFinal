import shodan
import logging

logging.basicConfig(filename = 'shodanAPI.log',
            level = logging.INFO , format = '%(asctime)s %(message)s', 
            datefmt = '%m/%d/%Y %I:%M:%S %p')


#Obtener informacion de la API
def info_API(ShodanApi):
    try:
        print("Esta es la informacion de la API:")
        info = ShodanApi.info() 
        for i in info:
            print('%s: %s ' % (i, info[i]))
    except:
        print("Hubo un error, intente de nuevo")
        logging.info("Algo salio mal con la API.")
        return rec_shodan()

#Limitar la busqueda de dispositivos
def busq_dis(ShodanApi):
    query = input("Escribe el termino de busqueda para los dispositivos: ")
    resultados = ShodanApi.search(query)
    print(f"Resultados encontrados: {resultados['total']}")
    try:
        limit = int(input("¿Cuantos resultados deseas ver?: "))
        if limit <= 10:
            for idx, resultado in enumerate(resultados['matches']):
                if idx >= limit:
                    break 
                ip = resultado['ip_str']
                print(f"{idx + 1}. IP: {ip} - {resultado['data']}")
        elif limit > 10:
            return busq_dis(ShodanApi)
        else: 
            print("Opcion no valida")
            return busq_dis(ShodanApi)
        
    except:
        print("Hubo un error en la eleccion de limites")
        logging.info("No se encontro nada")
        return busq_dis(ShodanApi)

#Buscar vulnerabilidades en un host
def busc_v(ShodanApi, ip):
    try:
        host = ShodanApi.host(ip)
        print(f"Informacion del host: {host['ip_str']}")
        print(f"Organizacion: {host.get('org', 'N/A')}")
        print(f"Sistema operativo: {host.get('os', 'N/A')}")
        print("Vulnerabilidades:")
        for vuln in host.get('vulns', []):
            print(f" - {vuln}")
    except:
        print("Hubo un error al introducir la ip, intente de nuevo")
        logging.info("Hubo un error al introduccir la ip")

#Funcion principal
def rec_shodan():
    try:
        mi_ApiKey = input("Escribe tu API key: ")
        api = shodan.Shodan(mi_ApiKey)
        info_API(api)

        busq_dis(api)

        ip = input("Escribe la IP para buscar vulnerabilidades: ")
        busc_v(api, ip)

    except:
        logging.info("Algo salio mal con la API .")


# Llamada principal
if __name__ == "__main__":
    rec_shodan()