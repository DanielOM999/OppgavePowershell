<#
.SYNOPSIS
    Stopper og deaktiverer Windows Update-tjenesten.
#>

# Sjekk om PowerShell kjører som administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
        ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Starter PowerShell som administrator..."
    Start-Process pwsh -Verb RunAs -ArgumentList "-File `"$PSCommandPath`""
    exit
}

# 1) Stopp tjenesten
Stop-Service -Name wuauserv -Force
Write-Host "Windows Update-tjenesten er stoppet."

# 2) Sett oppstartstype til deaktivert
Set-Service   -Name wuauserv -StartupType Disabled
Write-Host "Windows Update-tjenesten er satt til Disabled ved oppstart."
