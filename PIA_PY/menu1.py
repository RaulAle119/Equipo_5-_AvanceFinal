from API_AbuseDataBase_Mau import menu_data
from Shodan import rec_shodan
from ContraseñaSegura import main_contraseña
from scan import main_scan
from mdatos import menu_meta

def menu():
    while True:
        print("Menu:")
        print("1.IP Abuse DataBase")
        print("2.Shodan")
        print("3.Escanear IP y puertos")
        print("4.Metadatos")
        print("5.Generador de contraseñas")
        print("6.Salir")

        opcion= input("Elige una opcion del menu: ")

        if opcion.isnumeric():
            opcion = int(opcion)
            
            if opcion == 1:
                menu_data()

            elif opcion ==  2 :
                rec_shodan()

            elif opcion == 3 :
                main_scan()
    
            elif opcion == 4 :
                menu_meta()
    
            elif opcion == 5 :
                main_contraseña()
    
            elif opcion == 6 :
                print("Adios")
                break
            else:
                print("Opcion no valida, por favor elige una opcion")


if __name__ == "__main__":
    menu()