@echo off
setlocal enabledelayedexpansion

set loopSecond=60
set runExePath=umdh.bat

echo RunExePath:%runExePath%
echo LoopSecond:%loopSecond%

set /a loopSecond+=1
:loop
start %runExePath%
ping -n %loopSecond% 127.0.0.1>nul
goto loop