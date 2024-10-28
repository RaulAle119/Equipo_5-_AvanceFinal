# Cambiamos la política de ejecución
try {
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -ErrorAction Stop
} catch {
    Write-Host "Error al cambiar la política de ejecución: $_"
    exit 1
}
#Asignamos una funcion la cual servira para buscar los archivos ocultos en la ruta deseada
function archivos_ocultos { param ([string]$ruta)

#Aqui escribimos unicamente el nombre de la carpeta, no la ruta
$carpeta = Read-Host "Por favor, proporciona el nombre de la carpeta a buscar"

#Buscara en todo el equipo el nombre de la carpeta
$directorio_raiz = "C:\"

$buscar = Get-ChildItem -Path $directorio_raiz -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq $carpeta }

#Dividimos en 2 posibles opciones, si encontro una carpeta con el nombre que pedimos
if ($buscar) {
    #Al encontrar una busqueda similar, imprimira todos los nombres de las carpetas que tengan en su direccion el nombre de la carpeta
    Write-Host "Se encontro la carpeta:"
    $buscar | ForEach-Object { Write-Host $_.FullName }
    $buscar | ForEach-Object { $ruta = $_.FullName }
    write-host $ruta
    #Busca los archivos ocultos dentro de la carpeta encontrada
        Write-Host "Buscando archivos ocultos en la carpeta $ruta"
        $busqueda = Get-ChildItem -Path $ruta -Recurse -Force | Where-Object { $_.Attributes -match 'Hidden' }
        #Si encuentra algun archivo oculto en la carpeta, nos indicara cuales son. AVISO: Tarda en cargar el programa, es normal debido a que busca en todo el equipo la carpeta. El tiempo no excede de los 3 minutos.
        if ($busqueda) {
            Write-Host "Archivos ocultos encontrados:"
            $busqueda | ForEach-Object { Write-Host $_.FullName }
        } else {
        #En caso de que no, nos avisara que no hay ninguno
            Write-Host "No se encontraron archivos ocultos en $ruta."
        }
#Al momento de escribir el nombre de la carpeta y no exista, nos aparecera este mensaje de que no hubo busquedas relacionadas
} else {
    Write-Host "No se encontraron carpetas con el nombre '$carpeta' en $directorio_raiz."
}
}
