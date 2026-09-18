@echo off
setlocal
title Ternary Bonsai 27B - llama.cpp Prism

if not defined PRISM_DIR set "PRISM_DIR=E:\llama-prism-clean"

if not exist "%PRISM_DIR%\llama-server.exe" (
  echo No se encuentra "%PRISM_DIR%\llama-server.exe".
  echo Define PRISM_DIR con la carpeta de la build de Prism.
  exit /b 1
)

pushd "%PRISM_DIR%"

echo.
echo Ternary Bonsai 27B - PQ2_0
echo Servidor: http://127.0.0.1:8080
echo.

llama-server.exe ^
  --models-preset "%~dp0..\config\modelos-web.ini" ^
  --models-max 1 ^
  --host 127.0.0.1 ^
  --port 8080

set "SERVER_EXIT=%ERRORLEVEL%"
popd

echo.
echo llama-server finalizo con codigo %SERVER_EXIT%.
pause
exit /b %SERVER_EXIT%
