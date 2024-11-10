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
    echo "Lista de Redes Disponibles"
    ip a || echo "Error al obtener la lista de redes."
}

monitoring_connections() {
    echo "Listado de Conexiones Activas"
    sudo netstat -ant || echo "Error al obtener el listado de conexiones."
}

monitoring_services() {
    echo "Listado de Servicios Activos"
    sudo systemctl list-units --type=service --state=active || echo "Error al obtener el listado de servicios."
}

open_ports() {
    echo "Puertos abiertos:"
    sudo ss -tuln || echo "Error al obtener la lista de puertos abiertos."
}

report() {
    echo "Generando reporte..."
    {
        echo "Redes disponibles:"
        ip a || echo "Error al obtener la lista de redes."
        echo ""
        echo "Conexiones activas:"
        sudo netstat -ant || echo "Error al obtener el listado de conexiones."
        echo ""
        echo "Servicios activos:"
        sudo systemctl list-units --type=service --state=active || echo "Error al obtener el listado de servicios."
        echo ""
        echo "Puertos abiertos:"
        sudo ss -tuln || echo "Error al obtener la lista de puertos abiertos."
    } > network_report.txt
    echo "Reporte generado en network_report.txt"
}


