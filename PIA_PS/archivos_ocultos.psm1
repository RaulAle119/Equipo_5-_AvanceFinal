<#
NOMBRE
archivos_ocultos #>
<#
SINOPSIS
Encuentra archivos ocultos.#>
<#
DESCRIPCION
Sirve para encontrar archivos ocultos en una carpeta determinada,en la cual el usuario describira el nombre de la carpeta a buscar. No sera necesario poner la ruta de la misma.#>
<#
EJEMPLO
archivos_ocultos { param([string]$Variable_ruta)
$Variable_carpeta = Read-Host "Nombre de la carpeta"
$Variable_directorio = Introducir ruta del directorio raiz, ya sea "C:\ o D:\"
$Variable_busqueda = Get-ChildItem -Path $Variable_directorio -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object {$_.Name -eq $Variable_carpeta}
if($Variable_busqueda) {
	Write-Host "Se encontro la carpeta:"
	$Variable_busqueda | ForEach-Object { Write-Host $_.FullName }
	$Variable_busqueda | ForEach-Object { $Variable_ruta = $_.FullName }
	Write-Host $Variable_ruta
		Write-Host "Buscando archivos ocultos en la carpeta $Variable_ruta"
		$busqueda = Get-ChildItem -Path $Variable_ruta -Recurse -Force | Where-Object { $_.Attributes -match 'Hidden' }
		if ($Variable_busqueda) {
			Write-Host "Archivos ocultos encontrados: "
			$Variable_busqueda | ForEach-Object { Write-Host $_.FullName }
		} else {
			Write-Host "No se encontraron archivos ocultos en $Variable_ruta"
		}
} else {
	Write-Host "No se encontraron carpetas con el nombre '$Variable_carpeta' en $Variable_directorio"
}
}#>
<#
NOTAS
Los nombres de las variables que se mostraron en el ejemplo son para que el usuario pueda distinguir y saber que hace cada uno, para evitar confusiones. Puede cambiar el nombre de cada una a eleccion personal.#>