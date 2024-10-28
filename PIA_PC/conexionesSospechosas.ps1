# ConexionesSospechosas.psm1
# Este módulo permite detectar conexiones de red sospechosas y consultar su reputación en VirusTotal.

# API Key de VirusTotal
$global:apiKey = "99247f14f373a307e57fec6a6e63d779488072f5adaf5ba82e3695c2ad5b489f"

# Función para configurar la API Key de VirusTotal (en caso de querer modificarla dinámicamente)
function Set-ApiKey {
    param (
        [string]$key  # Nueva clave de la API
    )
    $global:apiKey = $key  # Almacenamos la clave de la API en una variable global
    Write-Host "API Key actualizada."
}

# Función para consultar la reputación de una IP en VirusTotal
function Consultar-VirusTotalIP {
    param (
        [string]$ip  # Dirección IP que se va a consultar
    )
    
    # Verificamos si se ha establecido una API Key
    if (-not $global:apiKey) {
        Write-Host "Error: No se ha configurado una API Key de VirusTotal."
        return
    }

    # URL de la API de VirusTotal para verificar la reputación de una IP
    $url = "https://www.virustotal.com/vtapi/v2/ip-address/report?apikey=$global:apiKey&ip=$ip"

    # Realizamos la solicitud GET a la API
    try {
        # Invoke-RestMethod envía la petición y recibe la respuesta en formato JSON
        $response = Invoke-RestMethod -Uri $url -Method Get
        return $response  # Retornamos la respuesta de la API
    } catch {
        # Si ocurre un error (por ejemplo, problemas de red), mostramos el mensaje
        Write-Host "Error al consultar la IP $ip en VirusTotal: $_"
        return $null  # Retornamos null si hay un error
    }
}

# Función para detectar conexiones sospechosas en el sistema
function Detectar-ConexionesSospechosas {
    # Obtener todas las conexiones TCP activas en el sistema (solo las que están en estado "Established")
    $conexiones = Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' }

    # Iteramos sobre cada conexión encontrada
    foreach ($conexion in $conexiones) {
        $ipRemota = $conexion.RemoteAddress  # Extraemos la IP remota de la conexión

        # Llamamos a la función para consultar la reputación de la IP remota en VirusTotal
        $resultadoVT = Consultar-VirusTotalIP -ip $ipRemota

        # Si la consulta fue exitosa y recibimos una respuesta
        if ($resultadoVT) {
            # VirusTotal devuelve response_code = 1 si la IP está en su base de datos
            if ($resultadoVT.response_code -eq 1) {
                # Revisamos cuántos "positives" tiene la IP (cuántos motores la marcaron como maliciosa)
                if ($resultadoVT.positives -gt 0) {
                    # Si hay reportes positivos, consideramos la IP como sospechosa
                    Write-Host "IP sospechosa detectada: $ipRemota con $($resultadoVT.positives) reportes positivos en VirusTotal"
                } else {
                    # Si no tiene reportes positivos, informamos que la IP es segura
                    Write-Host "IP $ipRemota no tiene reportes negativos en VirusTotal."
                }
            } else {
                # Si response_code es diferente de 1, significa que VirusTotal no tiene información sobre la IP
                Write-Host "IP $ipRemota no se encuentra en la base de datos de VirusTotal."
            }
        }
    }
}
