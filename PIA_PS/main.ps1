<#
.SYNOPSIS
Menu principal, muestra opciones que el usuario podra elegir.#>
<#
.DESCRIPTION
En este menu el usuario podra elegir una de las 5 opciones que corresonden a diferente tareas:
1) Revision de archivos Hashes: Pedira al usuario ingresar el archivo hash que desee analizar
2) Buscar Archivos Ocultos: Le pedira al usuario el nombre de la carpeta que desea buscar
3) Revison de recursos del sistema: Arrojara una tabla de datos sobre el Procesador, Disco, RAM y Red
4) Revisar Conexiones sospechosas: analizara y arrojara una lista de las conoxiones actuales y sus reportes de seguridad.
5) Salir: Corta la ejecucion #>
<#
.NOTES
Este menu usa funiones de los modulos creados por nosotros, puede elegir una opcion del 1 al 5#>
<#
.EXAMPLE
PS C:\[RUTA DEL ARCHIVO] get-help.\main.ps1 -full #>

New-ModuleManifest -Path "C:\Users\raulg\Desktop\AV_FINAL\PIA_PS\VirusTotalReport.psd1" -RootModule "C:\Users\raulg\Desktop\AV_FINAL\PIA_PS\VirusTotalReport.psm1"
Import-Module "C:\Users\raulg\Desktop\AV_FINAL\PIA_PS\VirusTotalReport.psm1"
Get-Module Get-VirusTotalReport

New-ModuleManifest -Path "C:\Users\raulg\Desktop\AV_FINAL\PIA_PS\Arch_Oc.psd1" -RootModule "C:\Users\raulg\Desktop\AV_FINAL\PIA_PS\Arch_Oc.psm1"
Import-Module "C:\Users\raulg\Desktop\AV_FINAL\PIA_PS\Arch_Oc.psm1" 
Get-Module archivos_ocultos 

New-ModuleManifest -Path "C:\Users\raulg\Desktop\AV_FINAL\PIA_PS\Recursos.psd1" -RootModule "C:\Users\raulg\Desktop\AV_FINAL\PIA_PS\Recursos.psm1"
Import-Module "C:\Users\raulg\Desktop\AV_FINAL\PIA_PS\Recursos.psm1" 
Get-Module Show-Resources

New-ModuleManifest -Path "C:\Users\raulg\Desktop\AV_FINAL\PIA_PS\conexionesSospechosas.psd1" -RootModule "C:\Users\raulg\Desktop\AV_FINAL\PIA_PS\conexionesSospechosas.psm1"
Import-Module "C:\Users\raulg\Desktop\AV_FINAL\PIA_PS\conexionesSospechosas.psm1" 
Get-Module Find-ConexionesSospechosas

# Directorio donde se guardaran los reportes
$directorioReportes = "C:\Users\raulg\Desktop\AV_FINAL\Reportes"

# Crear el directorio si no existe
if (!(Test-Path -Path $directorioReportes)) {
    New-Item -ItemType Directory -Path $directorioReportes
}

do {
    Write-Host "Elija una opcion"
    Write-Host "1) Revision de archivos hashes"
    Write-Host "2) Buscar archivos ocultos"
    Write-Host "3) Revision de uso de recursos del sistema"
    Write-Host "4) Revisar conexiones sospechosas"
    Write-Host "5) Ayuda"
    Write-Host "6) Salir"

    $opcion = Read-Host

    switch ($opcion) {
        1 {
            # Llamar a la funcion y almacenar la salida
            $reporteHash = Get-VirusTotalReport | Out-String
            
            # Mostrar en pantalla
            Write-Host "Reporte de archivos hashes:"
            Write-Host $reporteHash
            
            # Guardar el archivo
            $rutaReporte = Join-Path -Path $directorioReportes -ChildPath "Reporte_Hashes_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').txt"
            $reporteHash | Out-File -FilePath $rutaReporte -Encoding UTF8
            Write-Host "Reporte de archivos hashes guardado en $rutaReporte"
        }
        2 {
            # Llamar a la funcion y almacenar la salida
            $reporteOcultos = archivos_ocultos | Out-String
            
            # Mostrar en pantalla
            Write-Host "Reporte de archivos ocultos:"
            Write-Host $reporteOcultos
            
            # Guardar el archivo
            $rutaReporte = Join-Path -Path $directorioReportes -ChildPath "Reporte_ArchivosOcultos_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').txt"
            $reporteOcultos | Out-File -FilePath $rutaReporte -Encoding UTF8
            Write-Host "Reporte de archivos ocultos guardado en $rutaReporte"
        }
        3 {
            # Llamar a la funcion y almacenar la salida
            $reporteRecursos = Show-Resources | Out-String
            
            # Mostrar en pantalla
            Write-Host "Reporte de uso de recursos del sistema:"
            Write-Host $reporteRecursos
            
            # Guardar el archivo
            $rutaReporte = Join-Path -Path $directorioReportes -ChildPath "Reporte_Recursos_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').txt"
            $reporteRecursos | Out-File -FilePath $rutaReporte -Encoding UTF8
            Write-Host "Reporte de uso de recursos guardado en $rutaReporte"
        }
        4 {
            # Llamar a la funcion y almacenar la salida
            $reporteConexiones = Find-ConexionesSospechosas | Out-String
            
            # Mostrar en pantalla
            Write-Host "Reporte de conexiones sospechosas:"
            Write-Host $reporteConexiones
            
            # Guardar el archivo
            $rutaReporte = Join-Path -Path $directorioReportes -ChildPath "Reporte_Conexiones_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').txt"
            $reporteConexiones | Out-File -FilePath $rutaReporte -Encoding UTF8
            Write-Host "Reporte de conexiones sospechosas guardado en $rutaReporte"
        }
        5 {
            python C:\Users\raulg\Desktop\AV_FINAL\helpps.py

        }
        6 {
            Write-Host "Saliendo del programa."
            exit
        }
        default {
            Write-Host "Opcion no valida"
        }
    }
} while ($opcion -ne 6)