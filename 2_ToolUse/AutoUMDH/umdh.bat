@echo off

set pidName=Demo.exe
set savePath=.\Log
set sumaryLog=sumLog.txt
set umdhExePath="umdh.exe"

if "%TIME:~0,1%"=="0" goto doubleHour
if "%TIME:~0,1%"=="1" goto doubleHour
if "%TIME:~0,1%"=="2" goto doubleHour
set hhmmss=0%TIME:~1,1%.%TIME:~3,2%.%TIME:~6,2%
goto endhhmm
:doubleHour
set hhmmss=%TIME:~0,2%.%TIME:~3,2%.%TIME:~6,2%
:endhhmm
set yyyymmdd=%DATE:~0,4%.%DATE:~5,2%.%DATE:~8,2%
set yyyymmddhhmmss=%yyyymmdd%.%hhmmss%

for /f "tokens=1,2,5,6" %%1 in ('tasklist /FI "IMAGENAME eq %pidName%" /NH') do (
echo %yyyymmddhhmmss%    PN: %%1 PID: %%2 Mem: %%3%%4 >> %savePath%\%sumaryLog%
%umdhExePath% -p:%%2 -f:%savePath%\%%2_%pidName%_%yyyymmdd%.%hhmmss%.log
)
exit