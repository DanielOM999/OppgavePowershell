<#
.SYNOPSIS
    Skript for å vise maskinstatus: generell info, CPU, minne, disk og nettverk.
#>

# 🖥️ Generell info
Write-Host "🖥️ Generell info:" -ForegroundColor Yellow
Write-Host "Bruker         : $Env:USERNAME"
Write-Host "Maskinnavn     : $Env:COMPUTERNAME"
$os = Get-CimInstance Win32_OperatingSystem
Write-Host "Operativsystem : $($os.Caption)"
Write-Host "Versjon        : $($os.Version)"
Write-Host "Oppetid        : $($os.LastBootUpTime)"

# 🧠 CPU
Write-Host "`n🧠 CPU:" -ForegroundColor Yellow
$cpu = Get-CimInstance Win32_Processor
Write-Host "Modell    : $($cpu.Name)"
Write-Host "Kjerner   : $($cpu.NumberOfCores)"
Write-Host "Tråder    : $($cpu.NumberOfLogicalProcessors)"
Write-Host "Belastning: $($cpu.LoadPercentage)%"

# 💾 Minne
Write-Host "`n💾 Minne:" -ForegroundColor Yellow
$mem = Get-CimInstance Win32_OperatingSystem
# Total og ledig i KB -> konverterer til GB
$totalGB = [math]::Round($mem.TotalVisibleMemorySize/1MB, 2)
$freeGB  = [math]::Round($mem.FreePhysicalMemory/1MB,      2)
$usedGB  = [math]::Round(($totalGB - $freeGB),             2)
Write-Host "Totalt    : $totalGB GB"
Write-Host "Brukt     : $usedGB  GB"
Write-Host "Ledig     : $freeGB  GB"

# 🗃️ Disker
Write-Host "`n🗃️ Disker:" -ForegroundColor Yellow
Get-CimInstance Win32_LogicalDisk |
  Where-Object { $_.DriveType -eq 3 } |
  ForEach-Object {
    $sizeGB = [math]::Round($_.Size/1GB,      2)
    $freeGB = [math]::Round($_.FreeSpace/1GB, 2)
    $usedGB = [math]::Round($sizeGB - $freeGB,2)
    Write-Host "$($_.DeviceID) : $usedGB GB brukt / $sizeGB GB totalt ($freeGB GB ledig)"
  }

# 🌐 Nettverk
Write-Host "`n🌐 Nettverk:" -ForegroundColor Yellow
Get-NetIPConfiguration |
  ForEach-Object {
    $alias = $_.InterfaceAlias
    Write-Host "`nAdapter       : $alias"
    # IPv4
    $ipv4 = $_.IPv4Address | ForEach-Object { "$($_.IPAddress)/$($_.PrefixLength)" }
    Write-Host "IP-adresse    : $($ipv4 -join ', ')"
    # Gateway
    $gw4 = $_.IPv4DefaultGateway.NextHop
    Write-Host "Gateway       : $gw4"
    # DNS
    $dns = $_.DNSServer | ForEach-Object { $_.ServerAddresses } | Select-Object -Unique
    Write-Host "DNS-servere   : $($dns -join ', ')"
  }
