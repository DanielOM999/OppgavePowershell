<#
.SYNOPSIS
    Eksporterer en liste over alle bildefiler under Documents-mappen til en tekstfil.

.PARAMETER RootPath
    Rotmappe for søket. Standardverdi: din Documents-mappe.

.PARAMETER OutputFile
    Full sti til tekstfilen som skal inneholde listen over bildefiler.
#>
param(
    [string]$RootPath  = "C:\Users\Danie\OneDrive - Buskerud fylkeskommune\Documents",
    [string]$OutputFile = "C:\Users\Danie\OneDrive - Buskerud fylkeskommune\Documents\Test23042025\Bildefiler.txt"
)

# 1) Konfigurer søkealternativer
$opts = [System.IO.EnumerationOptions]::new()
$opts.RecurseSubdirectories = $true
$opts.IgnoreInaccessible    = $true

# 2) Forbered tekstfilen – slett eksisterende innhold eller opprett ny
Set-Content -Path $OutputFile -Value '' -Encoding UTF8

# 3) Definer filtyper som skal inkluderes
$extensions = @('*.jpg','*.jpeg','*.png','*.gif','*.bmp','*.tiff','*.svg')

# 4) Finn filer og skriv både til konsoll og fil
foreach ($ext in $extensions) {
    [System.IO.Directory]::EnumerateFiles($RootPath, $ext, $opts) |
        ForEach-Object {
            Write-Output $_
            $_ | Out-File -FilePath $OutputFile -Append -Encoding UTF8
        }
}

Write-Output "Liste over bildefiler lagret i:`n$OutputFile"
