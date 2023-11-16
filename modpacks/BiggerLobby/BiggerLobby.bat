:biggerlobby
cls
title Lethal Company Modded - BiggerLobby
echo Please select a version
echo.
echo 1 - Stable Release
echo 2 - Beta Release
powershell -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Naidru/LethalCompanyInstaller/main/install-mods.ps1'))"
