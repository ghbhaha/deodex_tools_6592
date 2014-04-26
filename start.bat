::
:: deodex tools for mt6592
:: Script created by suda
:: Version : 1.0
:: File    : deodex.bat
:: Usage   : 1. put app and framework folder into system folder(system\app\*.apk,*.odex;system\framework\*.jar,*.odex)
::           2. start by double click start.bat
:top
@echo off
color 1e
mode con cols=58 lines=30
set /p api_level=<"tools\api_level.txt"
set /p smali_version=<"tools\use_this_version.txt"
title odex �ϲ�����(6592����)
:menu
cls
echo.
echo +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
echo I                                                       I
echo I                odex �ϲ�����(6592����)                I
echo I                                                       I
echo I                   made by suda                        I
echo +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
echo --------------------------------------------------------
echo ��ǰAPIΪ%api_level%��smali�汾Ϊ%smali_version%
echo �����޸�,����tools�ļ����޸�api_level.txt��use_this_version.txt
echo --------------------------------------------------------
echo.  [ѡ����Ž��в���]
echo --------------------------------------------------------
echo   1.�ϲ�ȫ��
echo   2.�ϲ�appĿ¼		
echo   3.�ϲ�frameworkĿ¼	
echo   0.�˳�����
echo. 
echo --------------------------------------------------------
echo.                            %date% %time%
set choice=
set /p choice= ѡ��[0-3]����:
IF NOT "%choice%"=="" SET choice=%choice:~0,2%
if /i "%choice%"=="0" EXIT
if /i "%choice%"=="1" goto all
if /i "%choice%"=="2" goto app
if /i "%choice%"=="3" goto framework
echo ѡ����Ч������������
echo.
ping 127.0.0.1 -n 2 >NUL
goto menu


rem �ϲ�����
:all
cls
if not exist system\app ( echo.
echo û�з���appĿ¼��������������
ping 127.0.0.1 -n 2 >NUL 
goto menu )
if not exist system\framework ( echo.
echo û�з���frameworkĿ¼��������������
ping 127.0.0.1 -n 2 >NUL
goto menu )
if exist log.txt( del log.txt )
echo ����Android��ܱ���....
if exist system\temp_framework ( rd /q /s system\temp_framework ) 
mkdir system\temp_framework\
xcopy system\framework system\temp_framework /E/Q >nul
for %%i in (bzip2.dll zip32z64.dll zip.exe) do copy tools\%%i system\framework\ >nul  
for %%i in (bzip2.dll zip32z64.dll zip.exe) do copy tools\%%i system\app\ >nul 
echo.
echo Android��ܱ������
echo.
echo ��ʼ�ϲ�frameworkĿ¼...
echo.
for /r system\framework\ %%a in (*.odex) do call :deodex_framework %%a
echo.
echo framework�ϲ����...
echo.
echo ��ʼ�ϲ�appĿ¼...
echo.
for /r system\app\ %%a in (*.odex) do call :deodex_app %%a
echo.
echo appĿ¼�ϲ����...
echo. 
echo ɾ��Android��ܱ���....
rd /q /s system\temp_framework
for %%i in (bzip2.dll zip32z64.dll zip.exe) do del /f system\app\%%i   
for %%i in (bzip2.dll zip32z64.dll zip.exe) do del /f system\framework\%%i  
echo.
echo �ϲ���ɣ������������˵�
echo.
ping 127.0.0.1 -n 2 >NUL
goto menu

rem �����ϲ�app
:app
cls
if not exist system\app ( echo.
echo û�з���appĿ¼��������������
ping 127.0.0.1 -n 2 >NUL
goto menu )
if exist log.txt( del log.txt )
echo ����Android��ܱ���....
if exist system\temp_framework ( rd /q /s system\temp_framework ) 
mkdir system\temp_framework\
xcopy system\framework system\temp_framework /E/Q >nul
for %%i in (bzip2.dll zip32z64.dll zip.exe) do copy tools\%%i system\app\ >nul 
echo.
echo ��ʼ�ϲ�appĿ¼...
echo.
for /r system\app\ %%a in (*.odex) do call :deodex_app %%a
echo. 
echo ɾ��Android��ܱ���....
rd /q /s system\temp_framework
for %%i in (bzip2.dll zip32z64.dll zip.exe) do del /f system\app\%%i    
echo.
echo appĿ¼�ϲ���ɣ������������˵�
echo.
ping 127.0.0.1 -n 2 >NUL
goto menu


rem �����ϲ�framework
:framework
cls
if not exist system\framework ( echo.
echo û�з���frameworkĿ¼��������������
ping 127.0.0.1 -n 2 >NUL 
goto menu )
if exist log.txt( del log.txt )
echo ����Android��ܱ���....
if exist system\temp_framework ( rd /q /s system\temp_framework ) 
mkdir system\temp_framework\
xcopy system\framework system\temp_framework /E/Q >nul
for %%i in (bzip2.dll zip32z64.dll zip.exe) do copy tools\%%i system\framework\ >nul 
echo.
echo ��ʼ�ϲ�frameworkĿ¼...
echo.
for /r system\framework\ %%a in (*.odex) do call :deodex_framework %%a
echo. 
echo ɾ��Android��ܱ���....
rd /q /s system\temp_framework
for %%i in (bzip2.dll zip32z64.dll zip.exe) do del /f system\framework\%%i    
echo.
echo frameworkĿ¼�ϲ���ɣ������������˵�
ping 127.0.0.1 -n 2 >NUL
echo.
goto menu



rem �ϲ�app����
:deodex_app
cd system
echo     ���ڽ� %~n1.odex ת��Ϊ classes.dex ...
java -Xmx512M -jar ..\tools\baksmali-%smali_version%.jar -a %api_level% -T ..\tools\fix_error -d temp_framework -x %1
java -Xmx512M -jar ..\tools\smali-%smali_version%.jar out -a %api_level% -o  app\classes.dex
if not exist app\classes.dex ( echo %~n1.apk�ϲ�ʧ��
for %%a in (..\log.txt) do echo %~n1.apk�ϲ�ʧ�� >>%%a
goto end )
del %1 /Q
rd out /Q /S
echo     ���ڽ� %~n1.apk �� classes.dex �ϲ�...
cd app
zip %~n1.apk -u classes.dex>nul
del classes.dex /Q
cd ..\..\
echo.
echo     ---- %~n1.apk�ϲ��ɹ� ----
echo.
for %%a in (.\log.txt) do echo %~n1.jar�ϲ��ɹ� >>%%a
goto end


rem �ϲ�framework����
:deodex_framework
cd system
echo     ���ڽ� %~n1.odex ת��Ϊ classes.dex ...
java -Xmx512M -jar ..\tools\baksmali-%smali_version%.jar -a %api_level% -T ..\tools\fix_error -d temp_framework -x %1 
java -Xmx512M -jar ..\tools\smali-%smali_version%.jar out -a %api_level% -o framework\classes.dex
if not exist framework\classes.dex ( echo %~n1.jar�ϲ�ʧ��
for %%a in (..\log.txt) do echo %~n1.jar�ϲ�ʧ�� >>%%a
goto end ) 
del %1 /Q
rd out /Q /S
echo     ���ڽ� %~n1.jar �� classes.dex �ϲ�...
cd framework
zip %~n1.jar -u classes.dex>nul
del classes.dex /Q
cd ..\..\
echo.
echo     ---- %~n1.jar�ϲ��ɹ� ---- 
echo.
for %%a in (.\log.txt) do echo %~n1.jar�ϲ��ɹ� >>%%a
goto end

:end