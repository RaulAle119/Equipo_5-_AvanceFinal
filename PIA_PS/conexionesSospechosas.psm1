# Cambiar la politica de ejecucion a Unrestricted (solo si es necesario)
function Set-PoliticaDeEjecucion {
    $politicaActual = Get-ExecutionPolicy

    if ($politicaActual -ne 'Unrestricted') {
        Write-Host "Cambiando la politica de ejecucion a 'Unrestricted'."
        Set-ExecutionPolicy Unrestricted -Scope Process -Force
    } else {
        Write-Host "La politica de ejecucion ya esta en 'Unrestricted'."
    }
}

# Llamar a la funcion para cambiar la política de ejecucion
Set-PoliticaDeEjecucion

# Funcion para solicitar la API Key al usuario (solo una vez por sesion)
function Get-ApiKey {
    if (-not $Script:ApiKey) {
        $Script:ApiKey = Read-Host -Prompt "Introduce tu clave API de VirusTotal"
        
        if (-not $Script:ApiKey) {
            Write-Host "No se proporciono ninguna API Key"
            return $null
        }
    }

    return $Script:ApiKey
}

# Funcion para consultar la reputacion de una IP en VirusTotal
function Invoke-VirusTotalIP {
    param (
        [string]$Ip    
    )
    
    $ApiKey = Get-ApiKey
    
    if (-not $ApiKey) {
        Write-Host "No se ha configurado una API Key de VirusTotal."
        return
    }

    # URL de la API de VirusTotal para verificar la reputacion de una IP
    $Url = "https://www.virustotal.com/vtapi/v2/ip-address/report?apikey=$ApiKey&ip=$Ip"

    try {
        $Response = Invoke-RestMethod -Uri $Url -Method Get
        return $Response  
    } catch {
        Write-Host "Error al consultar la IP $Ip en VirusTotal: $_"
        return $null  
    }
}

# Funcion para detectar conexiones sospechosas en el sistema
function Find-ConexionesSospechosas {
    $ApiKey = Get-ApiKey
    
    if (-not $ApiKey) {
        Write-Host "Error: No se ha configurado una API Key de VirusTotal."
        return
    }

    $Conexiones = Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' }

    foreach ($Conexion in $Conexiones) {
        $IpRemota = $Conexion.RemoteAddress  

        $ResultadoVT = Invoke-VirusTotalIP -Ip $IpRemota

        if ($ResultadoVT) {
            if ($ResultadoVT.response_code -eq 1) {
                if ($ResultadoVT.positives -gt 0) {
                    Write-Host "IP sospechosa detectada: $IpRemota con $($ResultadoVT.positives) reportes positivos en VirusTotal"
                } else {
                    Write-Host "IP $IpRemota no tiene reportes negativos en VirusTotal."
                }
            } else {
                Write-Host "IP $IpRemota no se encuentra en la base de datos de VirusTotal."
            }
        }
    }
}

