@echo off
title Winget Utility Menu
color 0A

:menu
cls
echo ==============================================
echo           WINGET UTILITY MENU
echo ==============================================
echo [1] Instalar aplicaciones
echo [2] Actualizar todas las aplicaciones
echo [3] Reparar App Installer (Winget)
echo [4] Salir
echo ==============================================
set /p choice=Elige una opción (1-4): 

if "%choice%"=="1" goto instalar
if "%choice%"=="2" goto actualizar
if "%choice%"=="3" goto reparar
if "%choice%"=="4" exit
goto menu

:instalar
cls
echo Instalando aplicaciones seleccionadas...
PowerShell -Command "winget install -e --id Google.Chrome"
PowerShell -Command "winget install -e --id 7zip.7zip"
PowerShell -Command "winget install -e --id Foxit.FoxitReader"
PowerShell -Command "winget install -e --id Skillbrains.Lightshot"
PowerShell -Command "winget install -e --id Bria.Bria"
PowerShell -Command "winget install -e --id Microsoft.DotNet.DesktopRuntime.7"
PowerShell -Command "winget install -e --id Microsoft.DotNet.Runtime.8"
PowerShell -Command "winget install -e --id VideoLAN.VLC"
PowerShell -Command "winget install -e --id Google.GoogleDrive"
PowerShell -Command "winget install -e --id Microsoft.PCManager"
echo.
echo Instalación completada.
pause
goto menu

:actualizar
cls
echo Actualizando todas las aplicaciones instaladas...
PowerShell -Command "winget update --all"
echo.
echo Actualización finalizada.
pause
goto menu

:reparar
cls
echo Reparando App Installer (Winget)...
PowerShell -Command "Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe"
echo.
echo Reparación completada.
pause
goto menu
