# Importar funciones
source redes2.sh
source esca_puertos.sh
# Mostrar el menu 
main() {
    echo ""
    echo "          MENU          "
    echo "------------------------"
    echo "Seleccione una opcion:"
    echo "1) Monitoreo de Red"
    echo "2) Monitoreo de Puertos"
    echo "3) Ayuda"
    echo "4) Salir"
}

while true; do
    main
    read -p "Opcion: " option

    case $option in
        1)
            main_network
            ;;
        2)
            escan_port  
            ;;
        3)  
            python3 helpbash1.py
            ;;
        4)
            break
            ;;
        *)
            echo "Opcion Invalida"
            ;;
    esac

    echo ""
done

