function Get-VirusTotalReport {
    param ()
    
    Write-Host "Ingresa tu API Key de VirusTotal:"
    $ApiKey = Read-Host
    
    Write-Host "Ingresa el Hash que desea analizar:"
    $Hash = Read-Host
    $uri = "https://www.virustotal.com/api/v3/files/$Hash"
    $headers = @{
        "x-apikey" = $ApiKey
    }

    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers
        $results = $response.data.attributes.last_analysis_results
        
        # Directorio donde se guardaran los reportes
        $directorioReportes = "C:\Users\raulg\Desktop\AV_FINAL\Reportes"
        if (!(Test-Path -Path $directorioReportes)) {
            New-Item -ItemType Directory -Path $directorioReportes
        }
        
        $output = "Reporte de analisis para el Hash: $Hash`n"
        $output += "------------------------------------------`n"
        
        foreach ($engineName in $results.PSObject.Properties.Name) {
            $engineResult = $results.$engineName
            $method = $engineResult.method
            $category = $engineResult.category
            $result = $engineResult.result

            $output += "Antivirus: $engineName`n"
            $output += "  Metodo: $method`n"
            $output += "  Clasificacion: $category`n"
            $output += "  Resultado: $result`n"
            $output += "----------------------------`n"
        }

        # Mostrar en pantalla el contenido del reporte
        return $output

        # Guardar el reporte en un archivo
        $rutaReporte = Join-Path -Path $directorioReportes -ChildPath "Reporte_VirusTotal_$Hash_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').txt"
        $output | Out-File -FilePath $rutaReporte -Encoding UTF8
        Write-Host "Reporte guardado en: $rutaReporte"
    }
    catch {
        Write-Host "Ocurrio un error al obtener el reporte de VirusTotal: $_"
    }
}