Clear-Host
$title = "Lethal Company Modded - More Company"
Write-Host "More Company"
Write-Host "------------"
Write-Host "A stable lobby player count expansion mod (8 max players)"
Write-Host ""
while ($true) {
    Write-Host "Please select a version"
    Write-Host ""
    Write-Host "1 - Stable Release"
    Write-Host "2 - Quit"
    $modver = Read-Host "Enter your selection"
    if ($modver -eq 1) {
        iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Naidru/LC-Modpack-Installer/main/modpacks/More%20Company/Install-MoreCompany.ps1'))
    }
    elseif ($modver -eq 2) {
        exit
    }
    else {
        Write-Host "Invalid Option!"
        Write-Host ""
    }
}
