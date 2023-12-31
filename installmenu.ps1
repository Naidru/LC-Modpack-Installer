$title = "Lethal Company - Modded Installation Kit - Created by Naidru"
Write-Host "What is this program?"
Write-Host "====================="
Write-Host "This is a Powershell script that contains a compilation of certain modpacks that are easy to install with 1 press of a button."
Write-Host "It will automatically download from the internet a selection of mods."
Write-Host ""
Write-Host "This program is based off of 'Krystilize's' BiggerLobby installer"
Write-Host ""
Write-Host ""
Write-Host "Created by Naidru"
Pause
Clear-Host
while ($true) {
    Write-Host "Please select a modpack"
    Write-Host ""
    Write-Host "1 - BiggerLobby Mod"
    Write-Host "2 - [MODPACK] Naidru's Pack"
    Write-Host "3 - Quit"
    $selection = Read-Host "Enter your selection"
    if ($selection -eq 1) {
        iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Naidru/LC-Modpack-Installer/main/modpacks/BiggerLobby/BiggerLobby.ps1'))
    }
    elseif ($selection -eq 2) {
        iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Naidru/LC-Modpack-Installer/main/modpacks/NaidrusPack/installer.ps1'))
    }
    elseif ($selection -eq 3) {
        exit
    }
    else {
        Write-Host "An invalid option was selected!"
        Write-Host ""
    }
}
