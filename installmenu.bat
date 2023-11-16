title Lethal Company - Modded Installation Kit - Created by Naidru
echo What is this program?
echo =====================
echo This is a batch file that contains a compilation of certain modpacks that are easy to install with 1 press of a button.
echo It will automatically download from the internet a selection of mods.
echo.
echo This program is based off of 'Krystilize's' BiggerLobby installer
echo.
echo.
echo Created by Naidru
pause
:menu
cls
echo Please select a modpack
echo.
echo 1 - BiggerLobby Mod
echo 2 - Quit
set /p select=
if %select% == 1 goto powershell -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Naidru/LethalCompanyInstaller/main/modpacks/BiggerLobby/BiggerLobby.bat'))"
if %select% == 2 exit
echo An invalid option was selected!
