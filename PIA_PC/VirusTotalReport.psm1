function Get-VirusTotalReport {
    param ([string]$ApiKey)
    
    Write-Host "Ingresa el Hash que desea analizar"
    $Hash = Read-Host
    $uri = "https://www.virustotal.com/api/v3/files/$Hash"
    $headers = @{
        "x-apikey" = "b5323ef020ab7a5600f682882c05417d58603b4e725d55841dab72902f76be59"
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