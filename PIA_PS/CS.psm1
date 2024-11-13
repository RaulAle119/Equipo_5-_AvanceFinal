# ConexionesSospechosas.psm1
# Este módulo permite detectar conexiones de red sospechosas y consultar su reputación en VirusTotal, guardando un reporte.

# Ubicación del archivo de reporte en formato txt
$ReportePath = "reporte_ConexionesSospechosas.txt"

# Función para inicializar el reporte
function inicializar-Reporte {
    # Crear archivo de reporte txt
    "Reporte de Conexiones Sospechosas" | Out-File -FilePath $ReportePath -Encoding UTF8
    Write-Host 'Archivo de reporte creado en $ReportePath'
}

# Función para solicitar la API Key al usuario (solo una vez por sesión)
function obtener-ApiKey {
    if (-not $Script:ApiKey) {
        $Script:ApiKey = Read-Host -Prompt "Introduce tu clave API de VirusTotal"
        
        if (-not $Script:ApiKey) {
            Write-Host "Error: No se proporcionó ninguna API Key. El proceso no puede continuar."
            return $null
        }
    }
    return $Script:ApiKey
}

# Función para consultar la reputación de una IP en VirusTotal
function consultar-VirusTotalIP {
    param (
        [string]$Ip
    )
    
    $ApiKey = Obtener-ApiKey
    if (-not $ApiKey) {
        Write-Host "Error: No se ha configurado una API Key de VirusTotal."
        return
    }

    $Url = "https://www.virustotal.com/vtapi/v2/ip-address/report?apikey=$ApiKey&ip=$Ip"

    try {
        $Response = Invoke-RestMethod -Uri $Url -Method Get
        return $Response
    } catch {
        Write-Host "Error al consultar la IP $Ip en VirusTotal: $_"
        return $null
    }
}

# Función para registrar los resultados en el reporte
function registrar-EnReporte {
    param (
        [string]$Ip,
        [int]$ReportesPositivos,
        [string]$Estado
    )

    # Formato de registro para el txt
    $registro = "IP Remota: $Ip`nReportes Positivos: $ReportesPositivos`nEstado: $Estado`n---" 
    $registro | Out-File -FilePath $ReportePath -Append -Encoding UTF8
}

# Función para detectar conexiones sospechosas en el sistema
function detectar-ConexionesSospechosas {
    inicializar-Reporte

    $ApiKey = Obtener-ApiKey
    if (-not $ApiKey) {
        Write-Host "Error: No se ha configurado una API Key de VirusTotal."
        return
    }

    $Conexiones = Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' }

    foreach ($Conexion in $Conexiones) {
        $IpRemota = $Conexion.RemoteAddress
        $ResultadoVT = Consultar-VirusTotalIP -Ip $IpRemota

        if ($ResultadoVT) {
            if ($ResultadoVT.response_code -eq 1) {
                if ($ResultadoVT.positives -gt 0) {
                    Write-Host "IP sospechosa detectada: $IpRemota con $($ResultadoVT.positives) reportes positivos en VirusTotal"
                    registrar-EnReporte -Ip $IpRemota -ReportesPositivos $ResultadoVT.positives -Estado "Sospechosa"
                } else {
                    Write-Host "IP $IpRemota no tiene reportes negativos en VirusTotal."
                    registrar-EnReporte -Ip $IpRemota -ReportesPositivos 0 -Estado "Segura"
                }
            } else {
                Write-Host "IP $IpRemota no se encuentra en la base de datos de VirusTotal."
                registrar-EnReporte -Ip $IpRemota -ReportesPositivos 0 -Estado "No en base de datos"
            }
        }
    }
}

# Exportamos las funciones que estarán disponibles para el usuario
Export-ModuleMember -Function obtener-ApiKey, consultar-VirusTotalIP, detectar-ConexionesSospechosas
