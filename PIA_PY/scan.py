import os
import socket
from concurrent.futures import ThreadPoolExecutor

# Funcion para escanear una direccion IP y sus puertos
def scan_ip(ip, ports):
    open_ports = []
    for port in ports:  
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            sock.settimeout(0.5)  
            result = sock.connect_ex((ip, port))
            if result == 0:
                open_ports.append(port)
    return ip, open_ports

# Funcion principal para escanear un rango de IPs
def scan_network(network):
    active_ips = []
    for i in range(1, 255):  
        ip = f"{network}.{i}"
        response = os.system(f"ping -n 1 -w 1000 {ip}")  
        if response == 0:
            active_ips.append(ip)
    return active_ips

# Funcion para ejecutar el escaneo
def main_scan():
    network = input("Introduce el rango de red (ej. 192.168.1): ")
    print("Escaneando la red...")
    
    active_ips = scan_network(network)
    print("IPs activas:", active_ips)  
    print(f"Número de IPs activas: {len(active_ips)}")  

    if active_ips: 
        ports_to_scan = range(1, 1025)  
        with ThreadPoolExecutor(max_workers=20) as executor:  
            futures = {executor.submit(scan_ip, ip, ports_to_scan): ip for ip in active_ips}
            for future in futures:
                ip, open_ports = future.result()
                if open_ports:  
                    print(f"IP: {ip}, Puertos abiertos: {open_ports}")

if __name__ == "__main__":
    main_scan()
