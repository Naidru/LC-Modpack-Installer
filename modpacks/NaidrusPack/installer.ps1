Clear-Host
$title = "Lethal Company Modded - Naidru's Pack"
Write-Host "Naidru's Pack"
Write-Host "-----------"
Write-Host "A collection of mods that I offer inside of a singular pack"
Write-Host ""
while ($true) {
    Write-Host "Please select a version"
    Write-Host ""
    Write-Host "1 - Install Pack [BepInEx]"
    Write-Host "2 - Quit"
    $modver = Read-Host "Enter your selection"
    if ($modver -eq 1) {
        iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Naidru/LC-Modpack-Installer/main/modpacks/NaidrusPack/install-mod.ps1'))
    }
    elseif ($modver -eq 2) {
        exit
    }

    else {
        Write-Host "Invalid Option!"
        Write-Host ""
    }
}

