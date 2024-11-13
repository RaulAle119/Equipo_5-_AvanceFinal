# Comprobar la IP
function escan_port() {
    # Definir nombre del archivo de reporte
    reporte="reporte_$(date +%Y-%m-%d_%H-%M-%S).txt"

    # Generar reporte
    echo "Reporte para la IP: $ip" > $reporte
    echo "Fecha: $(date)" >> $reporte
    echo "" >> $reporte

    if [ -z "$1" ]; then
        read -p "Ingresa una direccion IP: " ip
        if [ -z "$ip" ]; then
            error_prog "No se proporciono una IP valida"
        fi
    else
        ip=$1
    fi

    # Verifica el formato de la IP
    if [[ ! $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        error_prog "El formato de la IP no es correcto. Ejemplo: 192.168.0.1"
    fi

    # Ingresar rango de puertos
    read -p "Ingrese el puerto inicial y final, separados por un espacio (por defecto 1 1024): " port_in port_fin

    # Valores predeterminados
    port_in=${port_in:-1}
    port_fin=${port_fin:-1024}

    # Verificar rango de puertos
    if ! [[ $port_in =~ ^[0-9]+$ && $port_fin =~ ^[0-9]+$ && $port_in -le $port_fin ]]; then
        error_prog "El rango de los puertos no es valido, ingreselos nuevamente."
    fi

    # Escaneo de puertos
    for port in $(seq $port_in $port_fin); do
        (echo >/dev/tcp/$ip/$port) >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "El puerto $port está abierto" | tee -a $reporte
        else
            echo "El puerto $port está cerrado" | tee -a $reporte
        fi
    done

    # Mostrar mensaje de finalización
    echo "El reporte ha sido guardado en $reporte."
}


