@echo off
chcp 65001 >nul
title Script Tong Hop MTK Tool
setlocal enabledelayedexpansion

echo ===================================================
echo     BAT DAU CHAY CHUONG TRINH TONG HOP
echo ===================================================
echo.

:: Luu lai thu muc goc
set "ROOT_DIR=%~dp0"

echo [+] Dang chay script 2 (mtkclient\patchboot.bat)...
if exist "%ROOT_DIR%mtkclient\patchboot.bat" (
    cd /d "%ROOT_DIR%mtkclient"
    call "patchboot.bat"
    echo [OK] Da xong script 2.
) else (
    echo [LOI] Khong tim thay file mtkclient\patchboot.bat
)

echo.
echo [+] Dang chay script 3 (mtkclient\apatchfix.bat)...
if exist "%ROOT_DIR%mtkclient\apatchfix.bat" (
    cd /d "%ROOT_DIR%mtkclient"
    call "apatchfix.bat"
    echo [OK] Da xong script 3.
) else (
    echo [LOI] Khong tim thay file mtkclient\apatchfix.bat
)

:: Quay tro ve thu muc ban dau
cd /d "%ROOT_DIR%"

echo.
echo ===================================================
echo     DA HOAN THANH TAT CA SCRIPT!
echo ===================================================
pause