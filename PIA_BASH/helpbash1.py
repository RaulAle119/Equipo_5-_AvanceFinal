import argparse

parser = argparse.ArgumentParser(
    description="Este es un modulo de ayuda para los programas de bash"
)
subparsers = parser.add_subparsers (title="Scripts de bash", dest="command")
esc_port_parser = subparsers.add_parser(
    "Escaneo-de-puertos",
    help="""Este script en Bash es para escanear puertos en una dirección IP específica, que se ingresa 
    cuando ejecutas el archivo. Verifica si los puertos están abiertos o cerrados entre un rango 
    que puedes especificar o que, si prefieres, toma por defecto. Es ideal para revisar conexiones 
    en una red local.""",
    description="Al momento de correr el script pregunta la IP, no es necesario introducirla al momento de ejecutar el programa."
)
main_redes_parser = subparsers.add_parser(
    "Monitoreo-de-redes",
    help="""Este script en Bash permite monitorear redes, conexiones, servicios, y puertos abiertos, 
    además de generar un reporte de toda esta información en un archivo.""",
    description="""Cuenta con un menu, las opciones 2 a 4 requieren permisos de administrador(sudo)"""
)
args = parser.parse_args()
if args.command == None:
    parser.print_help()
else:
    subparser_dict = {
        "Escaneo-de-puertos": esc_port_parser,
        "Monitoreo-de-redes": main_redes_parser
    }
    subparser_dict[args.command].print_help()