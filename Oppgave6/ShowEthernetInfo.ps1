<#
.SYNOPSIS
    Finner alle aktive Ethernet-adaptere og viser detaljert IP-konfigurasjon.

.DESCRIPTION
    1) Filtrerer nettverksadaptere med status "Up" og navn som inneholder "Ethernet".
    2) Viser enten bare navn (hvis -RawList) eller full IP-konfigurasjon for hver.
#>
param(
    [switch]$RawList
)

# 1) Hent aktive Ethernet-adaptere
$adapters = Get-NetAdapter `
    | Where-Object { $_.Status -eq 'Up' -and $_.Name -like '*Ethernet*' }

if (-not $adapters) {
    Write-Warning "Fant ingen aktive Ethernet-adaptere."
    exit 1
}

# 2) Vis kun navn hvis -RawList er satt
if ($RawList) {
    $adapters.Name | ForEach-Object { Write-Output $_ }
    exit 0
}

$opts = [System.IO.EnumerationOptions]::new()
$opts.RecurseSubdirectories = $true
$opts.IgnoreInaccessible    = $true

# 3) Gå gjennom og vis detaljer for hver adapter
foreach ($ad in $adapters) {
    $alias = $ad.Name
    Write-Host "`n=== Adapter: $alias ===" -ForegroundColor Cyan

    Get-NetIPConfiguration -InterfaceAlias $alias `
      | Format-List `
          InterfaceAlias,
          InterfaceIndex,
          InterfaceDescription,
          @{Name='NetProfile.Name';Expression={$_.NetProfile.Name}},
          IPv4Address,
          IPv6Address,
          IPv4DefaultGateway,
          IPv6DefaultGateway,
          DNSServer
}
