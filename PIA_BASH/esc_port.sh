#!/bin/bash
#Al momento que se va a abrir el archivo se tiene que indicar la IP. Ej: ./esc_port.sh 000.000.00.0
#La funcion sirve para marcar error si no se ingreso la IP correctamente
function error_prog() {
 echo "Error: $1"
 exit 1
}

#Comprobar la IP
function escan_port() {
 if [ -z "$1" ]; then
  error_prog "No se proporcino la dirección IP"
  read -p "Ingresa una direccion IP: " ip
 else
  ip=$1
 fi
 
 # Verifica si la direccion IP dada se encuentra en el formato establecido
 if [[ ! $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
  error_prog "El formato de la IP no es correcto, el formato debe ser como el ejemplo siguiente: 192.168.0.1"
 fi

 #Ingresa el rango de puertos, indicados con un espacio
 read -p "Ingrese el puerto inicial y final, separados por un espacio (por defecto 1 1024): " port_in port_fin

 #En dado caso de que no se indiquen los puertos, se usaran los valores predeteminados
 port_in=${port_in:-1}
 port_fin=${port_fin:-1024}

 #Se hace una verificacion de que los puertos y rango sean validos
 if ! [[ $port_in =~ ^[0-9]+$ && $port_fin =~ ^[0-9]+$ && $port_in -le $port_fin ]]; then
  error_prog "El rango de los puertos no es valido, ingresalos nuevamente."
 fi

 #Se escanean los puertos del 1 al 1024
 for port in $(seq $port_in $port_fin); do
   # Intenta conectar al puerto usando bash y /dev/tcp
   (echo >/dev/tcp/$ip/$port) >/dev/null 2>&1
   #Comprueba el estado de la conexion
   if [ $? -eq 0 ]; then
     echo "El puerto $port esta abierto"
   else
     echo "El puerto $port esta cerrado"
   fi
 done
}
#Llamar a la funcion
escan_port "$@"
