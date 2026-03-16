@echo off
title HelpDesk IT - Automatizador de Tareas
echo ==========================================
echo   CONSULTA DE IDIOMA DEL SISTEMA (DISM)
echo ==========================================
dism /online /get-intl
pause

echo Bienvenido %username%, deseas continuar?
pause>nul

:start
cls
echo ********************
echo *** HelpDesk IT ****
echo ********************
echo.
echo 1. Ver Serie del Equipo
echo 2. Ver Version BIOS
echo 3. Abrir MSINFO32
echo 4. Configurar Usuarios sin Expiracion
echo 5. Ver HostName
echo 6. Cambiar HostName
echo 7. Actualizar Programas con WinGet (Upgrade)
echo 8. Buscar Actualizaciones con WinGet (Update All)
echo 9. Sincronizar Hora
echo 10. Bloquear Fondo de Pantalla (ON)
echo 11. Desbloquear Fondo de Pantalla (OFF)
echo 12. Reparar PC (SFC, DISM, CHKDSK)
echo 13. Instalar Herramientas Esenciales (WinGet)
echo 14. Reparar WinGet
echo 15. Instalar Windows 11 25H2 (Product Server)
echo.
echo 0. SALIR
echo.

set /p "valor=Selecciona una opcion: "

REM Validar que la entrada sea un numero
for /f "delims=0123456789" %%i in ("%valor%") do (
    if not "%%i"=="" (
        goto ERROR_OPCION
    )
)

if "%valor%"=="0" goto SALIR
if "%valor%"=="1" goto SERIAL
if "%valor%"=="2" goto BIOS
if "%valor%"=="3" goto MSINFO
if "%valor%"=="4" goto USERS
if "%valor%"=="5" goto HOST
if "%valor%"=="6" goto HOSTNAME
if "%valor%"=="7" goto WINGET_UPGRADE
if "%valor%"=="8" goto WINGET_UPDATE
if "%valor%"=="9" goto HORA
if "%valor%"=="10" goto BLOCKWALLPAPER_ON
if "%valor%"=="11" goto BLOCKWALLPAPER_OFF
if "%valor%"=="12" goto REPAIR_PC
if "%valor%"=="13" goto TOOLS
if "%valor%"=="14" goto REPAIR_WINGET
if "%valor%"=="15" goto WIN25H2

:ERROR_OPCION
cls
echo ERROR: Opcion no valida, por favor intenta de nuevo.
echo.
pause
goto start

REM --- Funciones ---

:WIN25H2
cls
echo --- Instalacion de Windows 11 25H2 (Product Server) ---
cd /d d:\
if exist "setup.exe" (
    echo [i] Iniciando instalacion en modo Server...
    setup.exe /product server
) else (
    echo [ERROR] No se encontro setup.exe en la raiz de la unidad D:.
)
echo.
pause
goto start

:TOOLS
cls
echo --- Instalando Herramientas Esenciales ---
echo Esto puede tomar unos minutos, por favor espere...
PowerShell winget install -e --id Google.Chrome
PowerShell winget install -e --id 7zip.7zip
PowerShell winget install -e --id Foxit.FoxitReader
PowerShell winget install -e --id Skillbrains.Lightshot
PowerShell winget install -e --id Bria.Bria
PowerShell winget install -e --id Microsoft.DotNet.DesktopRuntime.7
PowerShell winget install -e --id Microsoft.DotNet.Runtime.8
PowerShell winget install -e --id VideoLAN.VLC
PowerShell winget install -e --id Google.GoogleDrive
PowerShell winget install -e --id Microsoft.PCManager
echo.
echo Instalacion de herramientas completada.
pause
goto start

:SERIAL
cls
echo --- Informacion de Serie del Equipo ---
wmic csproduct get name, identifyingnumber
echo.
pause
goto start

:BIOS
cls
echo --- Version del BIOS ---
wmic bios get smbiosbiosversion
echo.
pause
goto start

:MSINFO
cls
echo --- Abriendo Informacion del Sistema (MSINFO32) ---
msinfo32
goto start

:USERS
cls
echo --- Configuracion de Usuarios sin Expiracion de Contrasena ---
echo Verificando y configurando usuarios...
net user Maxitransfers /expires:never
net user User /expires:never
net accounts /maxpwage:unlimited
echo.
echo Configuracion de usuarios completada.
echo Recuerda que las cuentas 'Maxitransfers' y 'User' deben existir.
pause
goto start

:HOSTNAME
cls
echo --- Cambiar Nombre de Host ---
SET /p "new_hostname=Introduce el nuevo nombre para el equipo: "
echo.
echo Cambiando el nombre del equipo a "%new_hostname%".
echo Esto puede requerir un reinicio del sistema para aplicar los cambios.
PowerShell Rename-Computer -NewName "%new_hostname%" -Force
echo.
pause
goto start

:HOST
cls
echo --- Nombre de Host Actual ---
hostname
echo.
pause
goto start

:REPAIR_WINGET
cls
echo --- Reparando WinGet ---
PowerShell Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
echo.
echo Reparacion de WinGet completada (o intentada).
pause
goto start

:WINGET_UPGRADE
cls
echo --- Actualizando Programas con WinGet (Upgrade) ---
echo Esto puede tomar un tiempo, por favor espere...
PowerShell winget upgrade --all
echo.
echo Actualizacion de programas completada.
pause
goto start

:WINGET_UPDATE
cls
echo --- Buscando Actualizaciones con WinGet (Update All) ---
echo Esto puede tomar un tiempo, por favor espere...
PowerShell winget upgrade --all
echo.
echo Busqueda y aplicacion de actualizaciones completada.
pause
goto start

:HORA
cls
echo --- Sincronizando Hora ---
w32tm /resync
echo.
echo Sincronizacion de hora completada.
pause
goto start

:BLOCKWALLPAPER_ON
cls
echo --- Bloqueando Fondo de Pantalla ---
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop /v NoChangingWallpaper /t REG_DWORD /d 0x00000001 /f
echo.
echo Fondo de pantalla bloqueado. Un reinicio de sesion puede ser necesario.
pause
goto start

:BLOCKWALLPAPER_OFF
cls
echo --- Desbloqueando Fondo de Pantalla ---
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop /v NoChangingWallpaper /t REG_DWORD /d 0x00000000 /f
echo.
echo Fondo de pantalla desbloqueado. Un reinicio de sesion puede ser necesario.
pause
goto start

:REPAIR_PC
cls
echo --- Iniciando Proceso de Reparacion del PC ---
echo Esto puede tardar bastante, por favor no cierre la ventana.

echo.
echo --- Ejecutando SFC /scannow (Verificacion de integridad de archivos del sistema) ---
sfc /scannow
echo SFC /scannow completado.

echo.
echo --- Ejecutando DISM /CheckHealth (Verificacion del estado de la imagen de Windows) ---
DISM /Online /Cleanup-Image /CheckHealth
echo DISM /CheckHealth completado.

echo.
echo --- Ejecutando DISM /ScanHealth (Analisis mas profundo del estado de la imagen de Windows) ---
DISM /Online /Cleanup-Image /ScanHealth
echo DISM /ScanHealth completado.

echo.
echo --- Ejecutando DISM /RestoreHealth (Reparacion de la imagen de Windows) ---
DISM /Online /Cleanup-Image /RestoreHealth
echo DISM /RestoreHealth completado.

echo.
echo --- Ejecutando CHKDSK C: /F /R (Verificacion y reparacion de disco C:) ---
echo ATENCION: CHKDSK puede requerir un reinicio para ejecutarse si el disco esta en uso.
chkdsk C: /F /R
echo CHKDSK C: /F /R completado.

echo.
echo Proceso de reparacion del PC finalizado.
pause
goto start

:SALIR
cls
echo * Puede encontrar mas scripts utiles en HelpDesk IT
timeout /t 3 >nul
EXIT
