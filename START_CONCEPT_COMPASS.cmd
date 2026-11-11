@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
title Concept Compass v1.3.0 Launcher

echo ============================================================
echo  CONCEPT COMPASS v1.3.0 - ACCESSIBILITY + SMART REVISION + MISTAKE NOTEBOOK
echo ============================================================
echo This launcher uses http://127.0.0.1:5199 and Worker port 8806.
echo It closes only stale Node Vite/Wrangler servers on the project ports.
echo.

where node.exe >nul 2>&1
if errorlevel 1 (
  echo ERROR: Node.js is not installed or is not on PATH.
  echo Install Node.js 20.19+ or 22.12+, then run this file again.
  pause
  exit /b 1
)
where npm.cmd >nul 2>&1
if errorlevel 1 (
  echo ERROR: npm.cmd was not found. Repair the Node.js installation.
  pause
  exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\reset-local-servers.ps1"

if not exist "node_modules\vite" (
  echo Installing frontend dependencies...
  call npm.cmd install
  if errorlevel 1 goto installfailed
)
if not exist "worker\node_modules\wrangler" (
  echo Installing learning-engine dependencies...
  pushd "%~dp0worker"
  call npm.cmd install
  set "INSTALL_RESULT=!ERRORLEVEL!"
  popd
  if not "!INSTALL_RESULT!"=="0" goto installfailed
)

if not exist "worker\.dev.vars" (
  copy "worker\.dev.vars.example" "worker\.dev.vars" >nul
  echo Created worker\.dev.vars from the example.
)
echo.
echo Building the frontend assets required by Wrangler...
call npm.cmd run build
if errorlevel 1 goto buildfailed
if not exist "dist\index.html" goto buildfailed

echo Frontend build is ready. Starting the AI Worker...
findstr /I /C:"paste-your-key-here" "worker\.dev.vars" >nul 2>&1
if not errorlevel 1 (
  echo.
  echo QuestShift needs a real Google AI Studio key in worker\.dev.vars.
  echo The key stays on your computer. Do not paste it into chat or frontend files.
  start "Edit local Gemini key" notepad.exe "%~dp0worker\.dev.vars"
  echo Save worker\.dev.vars, then return here and press any key.
  pause >nul
)

start "Concept Compass Worker - 8806" /D "%~dp0worker" cmd /k npm.cmd run dev
timeout /t 5 /nobreak >nul
start "Concept Compass Website - 5199" cmd /k npm.cmd run dev
timeout /t 4 /nobreak >nul
start "" "http://127.0.0.1:5199/"
echo.
echo Concept Compass v1.3.0 started. Keep both terminal windows open.
echo If AI is unavailable, read the QuestShift Status message shown in the app.
pause
exit /b 0

:installfailed
echo.
echo ERROR: Dependency installation failed. Check your internet connection and Node.js version.
echo Do not share your API key. Review the first npm error above.
pause
exit /b 1

:buildfailed
echo.
echo ERROR: Frontend build failed or dist\index.html was not created.
echo The AI Worker needs this folder because worker\wrangler.toml serves ../dist as local assets.
echo Read the npm build error above, then run: npm.cmd run build
pause
exit /b 1
