@echo off

setlocal EnableDelayedExpansion
for /f "tokens=*" %%i in ('findstr \"name\" info.json') do (
    set "Line=%%i"
    set "Line=!Line:* "=!"
)
set "Modname=!Line:",=!"

for /f "tokens=*" %%i in ('findstr \"version\" info.json') do (
    set "Line=%%i"
    set "Line=!Line:* "=!"
)
set "Version=!Line:",=!"
echo Preparing to publish %Modname% Version %Version%...

set Moddir=%~dp0
set Moddir=!Moddir:~0,-1!
echo %Moddir%

echo Copying files from %Moddir% to temp\%Modname%...
cd ..
xcopy /S /I /E %Moddir% temp\%Modname% /EXCLUDE:%Moddir%\publish_exclude.txt
cd temp
echo Compressing %Modname%_%Version%.zip...
7z a ..\%Modname%_%Version%.zip %Modname%

echo Cleaning up temporary files...
rd /S /Q %Modname%

echo Finished publishing %Modname% Version %Version%.
