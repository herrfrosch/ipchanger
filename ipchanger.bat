@echo off
:checkIP
for /f "skip=1 delims={}, " %%A in ('wmic nicconfig get ipaddress') do for /f "tokens=1" %%B in ("%%~A") do set "IP=%%~B"
for /F "tokens=2 delims=:" %%a in ('netsh interface ip show addresses "Wi-Fi" ^| find "DHCP enabled"') do set DHCP=%%a
for /f "delims=() tokens=2" %%a in (
    'netsh int ip show config "Wi-Fi" ^| findstr /r "(.*)"'
) do for %%b in (%%a) do set curr_mask=%%b
:menu
if exist %TMP%\currentip-ipchanger.txt (
    set /p ipadrr=<%TMP%\currentip-ipchanger.txt
) 
if not exist %TMP%\currentip-ipchanger.txt (
  set ipadrr=192.168.0.1
  echo %ipadrr%>%TMP%\currentip-ipchanger.txt  
)
if exist %TMP%\currentmask-ipchanger.txt (
    set /p mask=<%TMP%\currentmask-ipchanger.txt
) 
if not exist %TMP%\currentmask-ipchanger.txt (
  set mask=255.255.255.0
  echo %mask%>%TMP%\currentmask-ipchanger.txt
)
cls
echo ===== IPchanger 1.1 =====
echo.
echo Current IP: %IP%
echo Subnet mask: %curr_mask%
echo DHCP enabled: %DHCP% 
echo.
echo 1. Set static IP: %ipadrr% / %mask%
echo 2. Set DHCP
echo 3. Change static IP address
echo 4. Change subnet mask
echo 5. Exit
set /p choice=
if %choice% == 1 (
    netsh interface ipv4 set address name = "Wi-Fi" static %ipadrr% %mask%
    goto eof
) 
if %choice% == 2 (
    netsh interface ipv4 set address name = "Wi-Fi" source = dhcp
    goto eof
)
if %choice% == 3 (
    cls
    set /p ipadrr= Enter new IP:
    goto saveChanges
)
if %choice% == 4 (
    cls
    set /p mask= Enter subnet mask:
    goto saveChanges 
)
if %choice% == 5 goto eof
:saveChanges
echo %ipadrr%>%TMP%\currentip-ipchanger.txt
echo %mask%>%TMP%\currentmask-ipchanger.txt
goto menu
:eof