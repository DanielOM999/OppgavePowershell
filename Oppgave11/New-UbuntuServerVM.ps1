<#
.SYNOPSIS
    Oppretter og konfigurerer en Ubuntu Server VM i VirtualBox.
#>
param(
    [string]$VmName   = 'Deafult',
    [string]$IsoPath  = 'C:\Users\Danie\Downloads\ubuntu-24.04.2-desktop-amd64.iso',
    [string]$VmFolder = "$HOME\VirtualBox VMs"
)

# 1) Opprett og registrer VM
VBoxManage createvm `
    --name $VmName `
    --ostype Ubuntu_64 `
    --register `
    --basefolder "$VmFolder"

# 2) Generelle VM-innstillinger
VBoxManage modifyvm $VmName `
    --memory 2048 `
    --vram 16 `
    --cpus 2 `
    --nic1 nat `
    --boot1 dvd `
    --boot2 disk

# 3) Legg til SATA‐kontroller
VBoxManage storagectl $VmName `
    --name "SATA Controller" `
    --add sata `
    --controller IntelAhci `
    --portcount 2

# 4) Opprett VDI‐disk (20 GB, dynamisk)
$vdipath = Join-Path -Path $VmFolder -ChildPath "$VmName\$VmName.vdi"
VBoxManage createmedium disk `
    --filename "$vdipath" `
    --size 20480 `
    --format VDI

# 5) Fest VDI som primær disk (port 0)
VBoxManage storageattach $VmName `
    --storagectl "SATA Controller" `
    --port 0 `
    --device 0 `
    --type hdd `
    --medium "$vdipath"

# 6) Fest ISO som CD-ROM (port 1)
VBoxManage storageattach $VmName `
    --storagectl "SATA Controller" `
    --port 1 `
    --device 0 `
    --type dvddrive `
    --medium "$IsoPath"

Write-Host "`nVM '$VmName' opprettet og klar for installasjon!" -ForegroundColor Green
