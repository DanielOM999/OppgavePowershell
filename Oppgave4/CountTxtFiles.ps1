<#
.SYNOPSIS
    Teller effektivt alle .txt-filer under en gitt sti, og hopper over utilgjengelige kataloger.

.PARAMETER RootPath
    hvor tellingen skal starte. Standardverdi: C:\

.EXAMPLE
    .\CountTxtFilesEfficient.ps1
    .\CountTxtFilesEfficient.ps1 -RootPath "D:\Projects"
#>
param(
    [Parameter(Mandatory = $false)]
    [string]$RootPath = 'C:\'
)

# Konfigurer alternativer for filoppramsing
$opts = [System.IO.EnumerationOptions]::new()
$opts.RecurseSubdirectories = $true      # Gå rekursivt gjennom undermapper
$opts.IgnoreInaccessible    = $true      # Hopp over filer og mapper uten tilgang

try {
    # Strøm og tell kun .txt-filer
    $total = [System.IO.Directory]::EnumerateFiles(
        $RootPath,
        '*.txt',
        $opts
    ) | Measure-Object | Select-Object -ExpandProperty Count

    Write-Output "Total .txt files under '$RootPath': $total"
}
catch {
    Write-Warning "Unexpected error: $_"
}
