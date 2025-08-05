@echo off
cls
echo ********************
echo *** HelpDesk IT ****
echo ********************
echo.
title Informacion del Sistema
color 0A

echo ==========================
echo INFORMACION DEL SISTEMA
echo ==========================
echo.

:: Nombre del equipo y del usuario actual
echo Nombre del Equipo: %COMPUTERNAME%
echo Usuario actual: %USERNAME%
:: Informacion del sistema operativo
echo Version de Windows:
ver
:: Detalles del sistema operativo
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type"

:start
echo.
echo 1. Ver serie del equipo
echo 2. Version BIOS
echo 3. MSINFO32
echo 4. Usuarios sin expiracion
echo 5. Ver HostName
echo 6. Cambiar HostName
echo 7. WinGet Upgrade
echo 8. WinGet Update
echo 9. Sincronizar hora
echo 10. Bloquear Wallpaper
echo 11. Desbloquear Wallpaper
echo 12. Reparar PC
echo 13. Instalar Herramientas
echo 14. Reparar WinGet
echo 0. Salir
echo.
set /p valor=Selecciona una opcion:

if "%valor%"=="0" goto SALIR
if "%valor%"=="1" goto SERIAL 
if "%valor%"=="2" goto BIOS
if "%valor%"=="3" goto MSINFO
if "%valor%"=="4" goto USERS
if "%valor%"=="5" goto HOST
if "%valor%"=="6" goto HOSTNAME
if "%valor%"=="7" goto WINGETUPGRADE
if "%valor%"=="8" goto WINGETUPDATE
if "%valor%"=="9" goto HORA
if "%valor%"=="10" goto BLOCKWALLPAPER_ON
if "%valor%"=="11" goto BLOCKWALLPAPER_OFF
if "%valor%"=="12" goto REPAIR_PC
if "%valor%"=="13" goto TOOLS
if "%valor%"=="14" goto REPAIR_WINGET

goto ERROR

:TOOLS
PowerShell winget install -e --id Google.Chrome
PowerShell winget install --id=7zip.7zip -e
PowerShell winget install --id=Foxit.FoxitReader -e
PowerShell winget install --id=Skillbrains.Lightshot -e
PowerShell winget install --id=Bria.Bria -e
PowerShell winget install --id=Microsoft.DotNet.DesktopRuntime.7 -e
PowerShell winget install --id=Microsoft.DotNet.Runtime.8 -e
PowerShell winget install --id=VideoLAN.VLC -e
PowerShell winget install --id=Google.GoogleDrive -e
PowerShell winget install --id=Microsoft.PCManager -e
pause
goto start

:SERIAL
echo.
wmic csproduct get name, identifyingnumber
pause
goto start

:BIOS
echo.
wmic bios get smbiosbiosversion
pause
goto start

:MSINFO
start msinfo32
goto start

:USERS
echo.
net user Maxitransfers /expires:never
net user User /expires:never
net accounts /maxpwage:unlimited
pause
goto start

:HOSTNAME
echo.
set /p hostname=Escribe el nuevo nombre del equipo:
PowerShell Rename-Computer -NewName %hostname%
pause
goto start

:HOST
echo.
echo Hostname:
hostname
pause
goto start

:REPAIR_WINGET
PowerShell Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
pause
goto start

:WINGETUPGRADE
PowerShell winget upgrade
pause
goto start

:WINGETUPDATE
PowerShell winget update --all
pause
goto start

:HORA
echo ===============================
echo   CONFIGURACION REGIONAL MX
echo ===============================
PowerShell Set-WinSystemLocale es-MX
PowerShell Set-WinUserLanguageList es-MX -Force
PowerShell Set-WinUILanguageOverride -Language es-MX
PowerShell Set-Culture es-MX
PowerShell Set-TimeZone -Id "Central Standard Time (Mexico)"
PowerShell Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "DisableAutoDaylightTimeSet" -Value 1 -Type DWord
PowerShell w32tm /resync
pause
goto start

:BLOCKWALLPAPER_ON
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoChangingWallpaper /t REG_DWORD /d 1 /f
pause
goto start

:BLOCKWALLPAPER_OFF
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoChangingWallpaper /t REG_DWORD /d 0 /f
pause
goto start

:REPAIR_PC
sfc /scannow
pause
DISM /Online /Cleanup-Image /CheckHealth
pause
DISM /Online /Cleanup-Image /ScanHealth
pause
DISM /Online /Cleanup-Image /RestoreHealth
pause
chkdsk C: /F /R
pause
goto start

:ERROR
cls
echo Opcion no valida, intenta otra vez.
pause
goto start

:SALIR
msg * Puedes encontrar mas scripts utiles en HelpDesk IT
exit
