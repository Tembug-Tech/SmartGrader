@echo off
REM Student Grade Calculator - Run Script

echo Running Student Grade Calculator...
echo.

REM Change to project directory
cd /d "%~dp0"

REM Run dart with full path
C:\flutter\bin\dart run lib\main.dart

echo.
pause
