import argparse
parser = argparse.ArgumentParser(
    description="Este es el modulo de ayuda de powershell donde se explica como usar los programas y sus dudas de como ejecutarse "
)
subparsers = parser.add_subparsers(title="Modulos", dest="command")
virustotal_parser = subparsers.add_parser(
    "Get-VirusTotalReport",
    help="Consulta el estado de un archivo en VirusTotal mediante su hash"
)

archivos_ocultos_parser = subparsers.add_parser(
    "archivos_ocultos",
    help="Busca archivos ocultos en una carpeta especificada"
)

Show_Resources_parser= subparsers.add_parser(
    "Show-Resources",
    help="Sirve para mostrar los recursos del sistema(CPU, memoria, disco, red...)"
)
Detectar_ConexionesSospechosas_parser = subparsers.add_parser(
    "Detectar-ConexionesSospechosas",
    help="Detecta conexiones TCP establecidas y consulta su reputacion en VirusTotal"
)

args = parser.parse_args()
if args.command == None:
    parser.print_help()
else:
    subparser_dict = {
        "Get-VirusTotalReport": virustotal_parser,
        "archivos_ocultos": archivos_ocultos_parser,
        "Show-Resources": Show_Resources_parser,
        "Detectar-ConexionesSospechosas": Detectar_ConexionesSospechosas_parser
    }
    subparser_dict[args.command].print_help()