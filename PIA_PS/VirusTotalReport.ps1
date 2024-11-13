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
        $results = $response.data.attributes.last_analysis_results | Format-List
        return $results
    }
    catch {
        Write-Host "Ocurrio un error al obtener el reporte de VirusTotal: $_"
    }
}