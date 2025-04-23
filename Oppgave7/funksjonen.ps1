## funksjonen lagt til i profilen på pc-en altså (notepad $PROFILE)

function Show-Eth4 {
    <#
    .SYNOPSIS
        Viser IPv4-adresse, gateway, DNS-servere og MAC-adresse for din Ethernet-adapter.
    #>

    # Overskrift
    Write-Host "=== Informasjon om Ethernet-adapter ===" -ForegroundColor Cyan

    # Finn første aktive Ethernet-adapter
    $adapter = Get-NetAdapter |
               Where-Object { $_.Status -eq 'Up' -and $_.Name -like '*Ethernet*' } |
               Select-Object -First 1

    if (-not $adapter) {
        Write-Warning "Fant ingen aktiv Ethernet-adapter."
        return
    }

    # Hent IP-konfigurasjon
    $cfg = Get-NetIPConfiguration -InterfaceIndex $adapter.InterfaceIndex

    # Formater IPv4-adresse(r) med prefiks
    $ipv4 = $cfg.IPv4Address |
            ForEach-Object { "{0}/{1}" -f $_.IPAddress, $_.PrefixLength }

    # Gateway
    $gw4  = $cfg.IPv4DefaultGateway.NextHop

    # DNS-servere
    $dns  = $cfg.DNSServer |
            ForEach-Object { $_.ServerAddresses } |
            Select-Object -Unique

    # MAC-adresse
    $mac  = $adapter.MacAddress

    # Skriv ut resultatene
    Write-Host ("IPv4-adresse : {0}" -f ($ipv4 -join ', '))
    Write-Host ("Gateway       : {0}" -f $gw4)
    Write-Host ("DNS-servere   : {0}" -f ($dns -join ', '))
    Write-Host ("MAC-adresse   : {0}" -f $mac)
}