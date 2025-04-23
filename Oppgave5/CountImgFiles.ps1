<#
.SYNOPSIS
    Lister opp alle vanlige bildefiler (.jpg, .png, osv.) under Documents-mappen, rekursivt.

.PARAMETER RootPath
    Rotmappe for søket. Standardverdi: din Documents-mappe.
#>
param(
    [string]$RootPath = "C:\Users\Danie\OneDrive - Buskerud fylkeskommune\Documents"
)

# 1) Konfigurer søkealternativer: rekursivt og hopp over utilgjengelige mapper
$opts = [System.IO.EnumerationOptions]::new()
$opts.RecurseSubdirectories = $true
$opts.IgnoreInaccessible    = $true

# 2) Definer hvilke bildeutvidelser som skal søkes etter
$extensions = @('*.jpg','*.jpeg','*.png','*.gif','*.bmp','*.tiff','*.svg')

# 3) Gå gjennom hver filtype og skriv ut funn til konsollen
foreach ($ext in $extensions) {
    [System.IO.Directory]::EnumerateFiles($RootPath, $ext, $opts) |
        ForEach-Object { Write-Output $_ }
}
