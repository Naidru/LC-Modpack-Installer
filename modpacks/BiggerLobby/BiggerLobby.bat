cls
:biggerlobby
title Lethal Company Modded - BiggerLobby
echo BiggerLobby
echo -----------
echo Allows lethal company lobbies to have up to 20 players!
echo.
echo Please select a version
echo.
echo 1 - Stable Release
echo 2 - Beta Release
echo 3 - Quit
set /p %modver% =
if %modver% == 1 goto stable
if %modver% == 2 goto beta
if %modver% == 3 exit
echo Invalid Option!
goto biggerlobby
:stable
powershell -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Naidru/LethalCompanyInstaller/main/modpacks/BiggerLobby/install-mod.ps1'))"
exit
:beta
powershell -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Naidru/LethalCompanyInstaller/main/modpacks/BiggerLobby/install-modBETA.ps1'))"
exit
