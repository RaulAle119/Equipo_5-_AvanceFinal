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

New-ModuleManifest -Path "C:\Users\raulg\Documents\GitHub\desktop-tutorial\PIA_PC\VirusTotalReport.psd1" -RootModule "C:\Users\raulg\Documents\GitHub\desktop-tutorial\PIA_PC\  VirusTotalReport.psm1"
Import-Module "C:\Users\raulg\Documents\GitHub\desktop-tutorial\PIA_PC\VirusTotalReport.psm1"
Get-Module Get-VirusTotalReport

New-ModuleManifest -Path "C:\Users\raulg\Documents\GitHub\desktop-tutorial\PIA_PC\Arch_Oc.psd1" -RootModule "C:\Users\raulg\Documents\GitHub\desktop-tutorial\PIA_PC\Arch_Oc.psm1"
Import-Module "C:\Users\raulg\Documents\GitHub\desktop-tutorial\PIA_PC\Arch_Oc.psm1" 
Get-Module archivos_ocultos 

New-ModuleManifest -Path "C:\Users\raulg\Documents\GitHub\desktop-tutorial\PIA_PC\Recursos.psd1" -RootModule "C:\Users\raulg\Documents\GitHub\desktop-tutorial\PIA_PC\Recursos.psm1"
Import-Module "C:\Users\raulg\Documents\GitHub\desktop-tutorial\PIA_PC\Recursos.psm1" 
Get-Module Show-Resources

New-ModuleManifest -Path "C:\Users\raulg\Documents\GitHub\desktop-tutorial\PIA_PC\conexionesSospechosas.psd1" -RootModule "C:\Users\raulg\Documents\GitHub\desktop-tutorial\PIA_PC\Recursos.psm1"
Import-Module "C:\Users\raulg\Documents\GitHub\desktop-tutorial\PIA_PC\Recursos.psm1" 
Get-Module Detectar-ConexionesSospechosas

do {
    Write-Host "Elija una opcion"
    Write-Host "1) Revision de archivos hashes"
    Write-Host "2) Buscar archivos ocultos"
    Write-Host "3) Revision de uso de recursos del sistema"
    Write-Host "4) Revisar Conexiones sospechosas"
    Write-Host "5) Salir"

    $opcion = Read-Host

    switch ($opcion) {
        1 {Get-VirusTotalReport}
        2{archivos_ocultos}
        3{Show-Resources}
        4{Detectar-ConexionesSospechosas}
        5 {exit}
    }
} while ($opcion -ne 5)
