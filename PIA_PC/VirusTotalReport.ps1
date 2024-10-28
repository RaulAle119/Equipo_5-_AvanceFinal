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
    function Scan-FilesInFolder {
        param ([string]$FolderPath, [string]$ApiKey)
        $files = Get-ChildItem -Path $FolderPath -File
        foreach ($file in $files) {
            try {
                $hash = Get-FileHash -Path $file.FullName -Algorithm SHA256
            
                $url = "https://www.virustotal.com/vtapi/v2/file/report?apikey=$ApiKey&resource=$($hash.Hash)"
                $response = Invoke-RestMethod -Uri $url -Method Get

                if ($response.response_code -eq 1) {
                    Write-Output "$($file.Name): $($response.positives)/$($response.total) antivirus lo marcaron como malicioso."
                } else {
                    Write-Output "$($file.Name): El archivo no se encuentra base de datos de VirusTotal."
                }
            }
            catch {
                Write-Output "Ocurrio un error con $($file.Name): $_"
            }
        }
    }
}