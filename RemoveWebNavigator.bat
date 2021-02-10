::Code-Kanopix
@ECHO OFF 
:: This batch file removes WebNavigatorBrowser from staskscheduler and from appdata.
TITLE Remove WebNavigator Adware
set /p computerName="Please enter ComputerName: "
:: Section 1: ping ComputerName.
ECHO ==========================
ECHO Pinging %computerName%
ECHO ============================

ping -n 1 "%computerName%" | findstr /c:"Reply from"

if %ERRORLEVEL% neq 0 goto ProcessError
ECHO Computer is Live!
Pause
goto Continues
:ProcessError
@rem process error
echo Computer is offline!
pause
exit /b 0

:: Section \2: Removes WebNavigator from taskscheduler
:Continues
cls
color 2E
ECHO ============================
ECHO Removing WebNavigator from taskscheduler on %computerName%
ECHO ============================
for /f "tokens=2 delims=\" %%x in ('schtasks /s %computerName% /query /fo:list ^| findstr BetterCloudSolutions') do schtasks /s %computerName% /Delete /TN \%%x\WebNavigatorBrowser-StartAtLogin /F
echo Successfully removed from task scheduler!
pause
cls

:: Section 3: Force Kill webnavigatorbrowser.exe running proccess
color 3E
ECHO ============================
ECHO Killing WebNavigator running process
ECHO ============================
taskkill /S %computerName% /IM "webnavigatorbrowser.exe" /F
echo process killed!
pause
cls

:: Section 4: Removes WebNavigator from appData.
color 4E
ECHO ============================
ECHO Removes WebNavigator from appData
ECHO ============================

net use W: \\%computerName%\c$\Users
setlocal enabledelayedexpansion
w:
set i = 0
::store folderNames into array
FOR /F "TOKENS=*" %%x IN ('dir /a:d /b') DO (
set /a "i+=1
set arr[!i!]=%%x
)
::display all array items
    set arr
::just line
cls
echo.===================================
::print array items (from 1 till n)
    set "len=!i!"
    set /a "len+=1"
    set "i=1"
    :loop
    echo %i%- !arr[%i%]! 
	set /a "i+=1"
    if %i% neq %len% goto:loop
  
  ::another way to create array arr.!i!=%%f
::promt

set /p id=Enter # of userProfile:
cls
set selectedProfile=!arr[%id%]!
cd %selectedProfile%\AppData\Local\
if exist WebNavigatorBrowser\ (
  echo WebNavigatorBrowser folder found!
  echo Removing folder WebNavigatorBrowser - Grab a coffee this might take a while.
  powershell Remove-Item -Recurse -Force 'WebNavigatorBrowser'
  dir
  pause
) else (

  echo Folder no longer exist!
  dir
  pause
  
)
endlocal
color 5E
net use W: /delete /y

ECHO ============================
ECHO Completed!
ECHO ============================
pause


