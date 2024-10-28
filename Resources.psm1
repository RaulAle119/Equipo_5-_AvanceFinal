function Show_Resources {

    function Get-CPUUsage {
        Get-WmiObject -Class Win32_Processor | ForEach-Object {
            [pscustomobject]@{
                CPU = $_.Name
                LoadPercentage = $_.LoadPercentage
            }
        }
    }
    function Get-MemoryUsage {
        Get-WmiObject -Class Win32_OperatingSystem | ForEach-Object {
            [pscustomobject]@{
                TotalMemoryGB = [math]::round($_.TotalVisibleMemorySize / 1MB, 2)
                FreeMemoryGB = [math]::round($_.FreePhysicalMemory / 1MB, 2)
                UsedMemoryGB = [math]::round(($_.TotalVisibleMemorySize - $_.FreePhysicalMemory) / 1MB, 2)
            }
        }
    }
    function Get-DiskUsage {
        Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | ForEach-Object {
            [pscustomobject]@{
                Drive = $_.DeviceID
                TotalSpaceGB = [math]::round($_.Size / 1GB, 2)
                FreeSpaceGB = [math]::round($_.FreeSpace / 1GB, 2)
                UsedSpaceGB = [math]::round(($_.Size - $_.FreeSpace) / 1GB, 2)
            }
        }
    }
    function Get-NetworkUsage {
        Get-NetAdapterStatistics | ForEach-Object {
            [pscustomobject]@{
                Adapter = $_.Name
                ReceivedBytesMB = [math]::round($_.ReceivedBytes / 1MB, 2)
                SentBytesMB = [math]::round($_.SentBytes / 1MB, 2)
            }
        }
    }

    Write-Host "Uso de CPU:"
    Get-CPUUsage | Format-Table -AutoSize
    Write-Host "`nUso de Memoria:"
    Get-MemoryUsage | Format-Table -AutoSize
    Write-Host "`nUso de Disco:"
    Get-DiskUsage | Format-Table -AutoSize
    Write-Host "`nUso de Red:"
    Get-NetworkUsage | Format-Table -AutoSize
}