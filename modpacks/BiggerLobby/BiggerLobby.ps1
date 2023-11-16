Clear-Host
$title = "Lethal Company Modded - BiggerLobby"
Write-Host "BiggerLobby"
Write-Host "-----------"
Write-Host "Allows lethal company lobbies to have up to 20 players!"
Write-Host ""
while ($true) {
    Write-Host "Please select a version"
    Write-Host ""
    Write-Host "1 - Stable Release"
    Write-Host "2 - Beta Release"
    Write-Host "3 - Quit"
    $modver = Read-Host "Enter your selection"
    if ($modver -eq 1) {
        iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Naidru/LethalCompanyInstaller/main/modpacks/BiggerLobby/install-mod.ps1'))
    }
    elseif ($modver -eq 2) {
        iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Naidru/LethalCompanyInstaller/main/modpacks/BiggerLobby/install-modBETA.ps1'))
    }
    elseif ($modver -eq 3) {
        exit
    }
    else {
        Write-Host "Invalid Option!"
        goto biggerlobby
    }
}
