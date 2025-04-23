<#
.SYNOPSIS
    Aktiverer og starter Windows Update-tjenesten.
#>

# Sjekk om PowerShell kjører som administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
        ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Starter PowerShell som administrator..."
    Start-Process pwsh -Verb RunAs -ArgumentList "-File `"$PSCommandPath`""
    exit
}

# 1) Sett oppstartstype til "Manual" (standard)
Set-Service -Name wuauserv -StartupType Manual
Write-Host "Windows Update-tjenesten er satt til Manual ved oppstart."

# 2) Start tjenesten hvis den ikke kjører
if ((Get-Service -Name wuauserv).Status -ne 'Running') {
    Start-Service -Name wuauserv
    Write-Host "Windows Update-tjenesten er startet."
}
else {
    Write-Host "Windows Update-tjenesten kjører allerede."
}
