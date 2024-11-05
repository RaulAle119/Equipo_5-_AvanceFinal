# ConexionesSospechosas.psm1
# Este módulo permite detectar conexiones de red sospechosas y consultar su reputación en VirusTotal.

# Función para solicitar la API Key al usuario (solo una vez por sesión)
function Obtener-ApiKey {
    if (-not $Script:ApiKey) {
        $Script:ApiKey = Read-Host -Prompt "Introduce tu clave API de VirusTotal"
        
        # Verificamos que la clave no esté vacía
        if (-not $Script:ApiKey) {
            Write-Host "Error: No se proporcionó ninguna API Key. El proceso no puede continuar."
            return $null
        }
    }

    return $Script:ApiKey
}

# Función para consultar la reputación de una IP en VirusTotal
function Consultar-VirusTotalIP {
    param (
        [string]$Ip    # Dirección IP que se va a consultar
    )
    
    # Solicitar la API Key al usuario si no está disponible
    $ApiKey = Obtener-ApiKey
    
    # Verificamos si se ha proporcionado una API Key
    if (-not $ApiKey) {
        Write-Host "Error: No se ha configurado una API Key de VirusTotal."
        return
    }

    # URL de la API de VirusTotal para verificar la reputación de una IP
    $Url = "https://www.virustotal.com/vtapi/v2/ip-address/report?apikey=$ApiKey&ip=$Ip"

    # Realizamos la solicitud GET a la API
    try {
        # Invoke-RestMethod envía la petición y recibe la respuesta en formato JSON
        $Response = Invoke-RestMethod -Uri $Url -Method Get
        return $Response  # Retornamos la respuesta de la API
    } catch {
        # Si ocurre un error (por ejemplo, problemas de red), mostramos el mensaje
        Write-Host "Error al consultar la IP $Ip en VirusTotal: $_"
        return $null  # Retornamos null si hay un error
    }
}

# Función para detectar conexiones sospechosas en el sistema
function Detectar-ConexionesSospechosas {
    # Solicitar la API Key al usuario si no está disponible
    $ApiKey = Obtener-ApiKey
    
    # Verificamos si se ha proporcionado una API Key
    if (-not $ApiKey) {
        Write-Host "Error: No se ha configurado una API Key de VirusTotal."
        return
    }

    # Obtener todas las conexiones TCP activas en el sistema (solo las que están en estado "Established")
    $Conexiones = Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' }

    # Iteramos sobre cada conexión encontrada
    foreach ($Conexion in $Conexiones) {
        $IpRemota = $Conexion.RemoteAddress  # Extraemos la IP remota de la conexión

        # Llamamos a la función para consultar la reputación de la IP remota en VirusTotal
        $ResultadoVT = Consultar-VirusTotalIP -Ip $IpRemota

        # Si la consulta fue exitosa y recibimos una respuesta
        if ($ResultadoVT) {
            # VirusTotal devuelve response_code = 1 si la IP está en su base de datos
            if ($ResultadoVT.response_code -eq 1) {
                # Revisamos cuántos "positives" tiene la IP (cuántos motores la marcaron como maliciosa)
                if ($ResultadoVT.positives -gt 0) {
                    # Si hay reportes positivos, consideramos la IP como sospechosa
                    Write-Host "IP sospechosa detectada: $IpRemota con $($ResultadoVT.positives) reportes positivos en VirusTotal"
                } else {
                    # Si no tiene reportes positivos, informamos que la IP es segura
                    Write-Host "IP $IpRemota no tiene reportes negativos en VirusTotal."
                }
            } else {
                # Si response_code es diferente de 1, significa que VirusTotal no tiene información sobre la IP
                Write-Host "IP $IpRemota no se encuentra en la base de datos de VirusTotal."
            }
        }
    }
}

# Exportamos las funciones que estarán disponibles para el usuario
Export-ModuleMember -Function Obtener-ApiKey, Consultar-VirusTotalIP, Detectar-ConexionesSospechosas
