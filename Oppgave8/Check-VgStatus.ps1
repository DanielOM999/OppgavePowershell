<#
.SYNOPSIS
    Sjekker om vg.no er tilgjengelig og viser HTTP-status til skjerm.
#>

# Nettadresse som skal sjekkes
$uri = 'https://vg.no'

try {
    # Send HTTP GET-forespørsel
    $resp = Invoke-WebRequest -Uri $uri -UseBasicParsing
    $code = $resp.StatusCode

    # Vurder respons
    if ($code -eq 200) {
        Write-Host "vg.no er OPPE (Status code: $code)"
    }
    else {
        Write-Host "vg.no er TILGJENGELIG, men retur­erte HTTP $code"
    }
}
catch {
    # Feilhåndtering: hent eventuell statuskode
    $code = $_.Exception.Response.StatusCode.value__
    Write-Host "vg.no er NED (Status code: $code)"
}
