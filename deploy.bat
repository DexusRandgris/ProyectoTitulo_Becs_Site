@echo off

REM Obtiene el ID del contenedor para eliminarlo
for /f "tokens=1" %%i in ('docker ps -a ^| findstr "db"') do set CONTAINER_ID=%%i
if not "%CONTAINER_ID%"=="" docker rm -f %CONTAINER_ID%

REM Obtiene el ID de la imagen para eliminar
for /f "tokens=3" %%i in ('docker images ^| findstr "db"') do set IMAGE_ID=%%i
if not "%IMAGE_ID%"=="" docker rmi -f %IMAGE_ID%

REM Obtiene el ID del contenedor para eliminarlo
for /f "tokens=1" %%i in ('docker ps -a ^| findstr "becs_proyecto_titulo"') do set CONTAINER_ID=%%i
if not "%CONTAINER_ID%"=="" docker rm -f %CONTAINER_ID%

REM Obtiene el ID de la imagen para eliminar
for /f "tokens=3" %%i in ('docker images ^| findstr "becs_proyecto_titulo"') do set IMAGE_ID=%%i
if not "%IMAGE_ID%"=="" docker rmi -f %IMAGE_ID%
REM Desplegar contenedor

docker compose up