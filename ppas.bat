@echo off
SET THEFILE=C:\Users\arnau\Documents\Lazarus Project\Warhammer\WarhammerHelp.exe
echo Linking %THEFILE%
C:\lazarus\fpc\3.2.2\bin\x86_64-win64\ld.exe -b pei-x86-64  --gc-sections   --subsystem windows --entry=_WinMainCRTStartup    -o "C:\Users\arnau\Documents\Lazarus Project\Warhammer\WarhammerHelp.exe" "C:\Users\arnau\Documents\Lazarus Project\Warhammer\link11164.res"
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occurred while assembling %THEFILE%
goto end
:linkend
echo An error occurred while linking %THEFILE%
:end
