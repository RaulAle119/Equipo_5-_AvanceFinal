main_network() {
    while true; do
        clear
        echo "       Monitoreo de Redes         " 
        echo "----------------------------------"
        echo "1) Monitoreo de redes"
        echo "2) Monitoreo de conexiones"
        echo "3) Monitoreo de servicios"
        echo "4) Ver puertos abiertos"
        echo "5) Generar Reporte" 
        echo "6) Salir"
        read -p "Seleccione una opción: " option
        
        case $option in
            1)
                network_monitoring
                ;;
            2)
                monitoring_connections
                ;;
            3)
                monitoring_services
                ;;
            4)
                open_ports
                ;;
            5)
                report
                ;;
            6)
                read -p "¿Esta seguro que desea salir? (s/n): " confirm
                if [[ $confirm == "s" ]]; then
                    break
                fi
                ;;
            *)
                echo "OPCION INVALIDA"
                ;;
        esac
        read -p "Presione [Enter] para continuar"
    done
}


network_monitoring() {
    echo "                      "
    echo "   Monitoreo de Red"
    echo "----------------------"

    ip a | awk '
    BEGIN { interface="" }
    /^[0-9]+: / {
        # Nueva interfaz encontrada, imprimir salto de linea para separacion
        if (interface != "") print "\n"
        interface=$2
        sub(/:/, "", interface)
        print "Interface:", interface
    }
    /mtu/ { print "  MTU:", $2 }
    /link\/ether/ { print "  MAC Address:", $2 }
    /inet / { print "  IPv4 Address:", $2, "(Mask: " $4 ")" }
    /inet6 / { print "  IPv6 Address:", $2, "(Scope: " $3 ")" }
    '

    
    echo "   Tabla de Enrutamiento"
    ip route || echo "Error al obtener la tabla de enrutamiento."
    echo
}


monitoring_connections() {
    echo "                      "
    echo "   Monitoreo de Conexiones"
    echo "----------------------"
    sudo netstat -ant || echo "Error al obtener el listado de conexiones."
    echo
}

monitoring_services() {
    echo "                      "
    echo "   Servicios Activos"
    echo "----------------------"
    sudo systemctl list-units --type=service --state=active || echo "Error al obtener el listado de servicios."
    echo
}

open_ports() {
    echo "                      "
    echo "   Puertos Abiertos"
    echo "----------------------"
    sudo ss -tuln || echo "Error al obtener la lista de puertos abiertos."
    echo
}

report() {
    eecho "                      "
    echo "Generando reporte..."
    echo "                       "

    {
        echo "                      "
        echo "   Estado de la Red"
        echo "----------------------"
        echo "Interfaces de Red:"
        ip a || echo "Error al obtener la lista de interfaces."
        echo
        echo "Tabla de Enrutamiento:"
        ip route || echo "Error al obtener la tabla de enrutamiento."
        echo

        echo "                      "
        echo "   Moitoreo de Conexiones"
        echo "----------------------------"
        sudo netstat -ant || echo "Error al obtener el listado de conexiones."
        echo

        echo "                      "
        echo "   Servicios Activos"
        echo "----------------------"
        sudo systemctl list-units --type=service --state=active || echo "Error al obtener el listado de servicios."
        echo

        echo "                      "
        echo "   Puertos Abiertos"
        echo "----------------------"
        sudo ss -tuln || echo "Error al obtener la lista de puertos abiertos."
    } > network_report.txt

    echo "Reporte generado en network_report.txt"
}


