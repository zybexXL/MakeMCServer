@echo off
setlocal

echo.
echo MakeMCServer 1.00 by Zybex - 09 Nov 2025
echo =====================================================================
echo This script will create a new hidden user account and add a shortcut
echo to launch a new MC Library Server instance running under that account
echo.

rem check for admin rights
net session 2> nul >nul && goto ok

echo Please run this as Administrator
pause
goto :EOF

:ok
set MCVER=none
for /L %%v in (1 1 69) do if exist c:\Windows\System32\MC%%v.exe set MCVER=%%v
if "%MCVER%"=="none" (
  echo Could not detect the installed MC version!
  set /p MCVER=Enter your current MC version [34]: || set MCVER=34
  echo.
)

set /p MCID=Enter MC instance number to create (1 to 9) [default=2]: || set MCID=2
set MCUSER=mcuser%MCID%
set MCPASS=mcpass%MCID%
set MCPORT=5220%MCID%

set CHECK=
net user %MCUSER% > nul 2>nul && set CHECK=*** WARNING! *** Account already exists!

echo.
echo Creating user account and settings for a new MC%MCVER% Library Server instance:
echo    MC version: Media Center %MCVER%
echo   Server port: %MCPORT%
echo  User account: %MCUSER%  %CHECK%
echo User password: %MCPASS%
echo.
echo Press ENTER to continue or CTRL+C to abort...
pause > nul

echo.
echo *** creating user account %MCUSER%
net user /add %MCUSER% %MCPASS% > nul
rem disable password expiry
powershell /c "set-localuser %MCUSER% -PasswordNeverExpires $true" > nul
rem hide user from windows login screen
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /f /t REG_DWORD /v %MCUSER% /d 0 > nul

rem save credentials - this will ask for the password
echo.
echo *** saving account password in vault - please enter the same password as above (%MCPASS%)
runas /savecred /user:%MCUSER% "cmd /c echo OK"

rem set new MC properties
echo.
echo *** Setting properties for new MC instance
runas /savecred /user:%MCUSER% "reg add \"HKCU\Software\J. River\Media Center %MCVER%\Library Server\" /f /v Port /d %MCPORT% /t REG_DWORD" > nul
runas /savecred /user:%MCUSER% "reg add \"HKCU\Software\J. River\Media Center %MCVER%\Properties\" /f /v \"General - Allow Multiple Instances\" /d 1 /t REG_DWORD" > nul
runas /savecred /user:%MCUSER% "reg add \"HKCU\Software\J. River\Media Center %MCVER%\Properties\" /f /v \"General - Windows Startup Run Mode\" /d 3 /t REG_DWORD" > nul
rem enabling Multiple Instances in main MC
reg add "HKCU\Software\J. River\Media Center %MCVER%\Properties" /v "General - Allow Multiple Instances" /f /d 1 /t REG_DWORD > nul

rem create launch scripts
echo *** creating desktop shortcut 
echo @runas /savecred /user:%MCUSER% "C:\Program Files\J River\Media Center %MCVER%\Media Center %MCVER%.exe" > "%USERPROFILE%\desktop\Start MC%MCID%.bat"

echo *** creating Start Menu shortcut (%%APPDATA%%\Microsoft\Windows\Start Menu\Programs\Startup)
echo @runas /savecred /user:%MCUSER% "C:\Program Files\J River\Media Center %MCVER%\Media Center %MCVER%.exe" /boot > "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Start MC%MCID%.bat"

echo.
echo *** All done! *** 
pause
:EOF
