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
title odex 合并工具(6592适用)
:menu
cls
echo.
echo +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
echo I                                                       I
echo I                odex 合并工具(6592适用)                I
echo I                                                       I
echo I                   made by suda                        I
echo +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
echo --------------------------------------------------------
echo 当前API为%api_level%，smali版本为%smali_version%
echo 如需修改,请至tools文件夹修改api_level.txt和use_this_version.txt
echo --------------------------------------------------------
echo.  [选择序号进行操作]
echo --------------------------------------------------------
echo   1.合并全部
echo   2.合并app目录		
echo   3.合并framework目录	
echo   0.退出程序
echo. 
echo --------------------------------------------------------
echo.                            %date% %time%
set choice=
set /p choice= 选择[0-3]操作:
IF NOT "%choice%"=="" SET choice=%choice:~0,2%
if /i "%choice%"=="0" EXIT
if /i "%choice%"=="1" goto all
if /i "%choice%"=="2" goto app
if /i "%choice%"=="3" goto framework
echo 选择无效，请重新输入
echo.
ping 127.0.0.1 -n 2 >NUL
goto menu


rem 合并所有
:all
cls
if not exist system\app ( echo.
echo 没有发现app目录，即将返回主单
ping 127.0.0.1 -n 2 >NUL 
goto menu )
if not exist system\framework ( echo.
echo 没有发现framework目录，即将返回主单
ping 127.0.0.1 -n 2 >NUL
goto menu )
if exist log.txt( del log.txt )
echo 创建Android框架备份....
if exist system\temp_framework ( rd /q /s system\temp_framework ) 
mkdir system\temp_framework\
xcopy system\framework system\temp_framework /E/Q >nul
for %%i in (bzip2.dll zip32z64.dll zip.exe) do copy tools\%%i system\framework\ >nul  
for %%i in (bzip2.dll zip32z64.dll zip.exe) do copy tools\%%i system\app\ >nul 
echo.
echo Android框架备份完成
echo.
echo 开始合并framework目录...
echo.
for /r system\framework\ %%a in (*.odex) do call :deodex_framework %%a
echo.
echo framework合并完成...
echo.
echo 开始合并app目录...
echo.
for /r system\app\ %%a in (*.odex) do call :deodex_app %%a
echo.
echo app目录合并完成...
echo. 
echo 删除Android框架备份....
rd /q /s system\temp_framework
for %%i in (bzip2.dll zip32z64.dll zip.exe) do del /f system\app\%%i   
for %%i in (bzip2.dll zip32z64.dll zip.exe) do del /f system\framework\%%i  
echo.
echo 合并完成，即将返回主菜单
echo.
ping 127.0.0.1 -n 2 >NUL
goto menu

rem 单独合并app
:app
cls
if not exist system\app ( echo.
echo 没有发现app目录，即将返回主单
ping 127.0.0.1 -n 2 >NUL
goto menu )
if exist log.txt( del log.txt )
echo 创建Android框架备份....
if exist system\temp_framework ( rd /q /s system\temp_framework ) 
mkdir system\temp_framework\
xcopy system\framework system\temp_framework /E/Q >nul
for %%i in (bzip2.dll zip32z64.dll zip.exe) do copy tools\%%i system\app\ >nul 
echo.
echo 开始合并app目录...
echo.
for /r system\app\ %%a in (*.odex) do call :deodex_app %%a
echo. 
echo 删除Android框架备份....
rd /q /s system\temp_framework
for %%i in (bzip2.dll zip32z64.dll zip.exe) do del /f system\app\%%i    
echo.
echo app目录合并完成，即将返回主菜单
echo.
ping 127.0.0.1 -n 2 >NUL
goto menu


rem 单独合并framework
:framework
cls
if not exist system\framework ( echo.
echo 没有发现framework目录，即将返回主单
ping 127.0.0.1 -n 2 >NUL 
goto menu )
if exist log.txt( del log.txt )
echo 创建Android框架备份....
if exist system\temp_framework ( rd /q /s system\temp_framework ) 
mkdir system\temp_framework\
xcopy system\framework system\temp_framework /E/Q >nul
for %%i in (bzip2.dll zip32z64.dll zip.exe) do copy tools\%%i system\framework\ >nul 
echo.
echo 开始合并framework目录...
echo.
for /r system\framework\ %%a in (*.odex) do call :deodex_framework %%a
echo. 
echo 删除Android框架备份....
rd /q /s system\temp_framework
for %%i in (bzip2.dll zip32z64.dll zip.exe) do del /f system\framework\%%i    
echo.
echo framework目录合并完成，即将返回主菜单
ping 127.0.0.1 -n 2 >NUL
echo.
goto menu



rem 合并app部分
:deodex_app
cd system
echo     正在将 %~n1.odex 转化为 classes.dex ...
java -Xmx512M -jar ..\tools\baksmali-%smali_version%.jar -a %api_level% -T ..\tools\fix_error -d temp_framework -x %1
java -Xmx512M -jar ..\tools\smali-%smali_version%.jar out -a %api_level% -o  app\classes.dex
if not exist app\classes.dex ( echo %~n1.apk合并失败
for %%a in (..\log.txt) do echo %~n1.apk合并失败 >>%%a
goto end )
del %1 /Q
rd out /Q /S
echo     正在将 %~n1.apk 与 classes.dex 合并...
cd app
zip %~n1.apk -u classes.dex>nul
del classes.dex /Q
cd ..\..\
echo.
echo     ---- %~n1.apk合并成功 ----
echo.
for %%a in (.\log.txt) do echo %~n1.jar合并成功 >>%%a
goto end


rem 合并framework部分
:deodex_framework
cd system
echo     正在将 %~n1.odex 转化为 classes.dex ...
java -Xmx512M -jar ..\tools\baksmali-%smali_version%.jar -a %api_level% -T ..\tools\fix_error -d temp_framework -x %1 
java -Xmx512M -jar ..\tools\smali-%smali_version%.jar out -a %api_level% -o framework\classes.dex
if not exist framework\classes.dex ( echo %~n1.jar合并失败
for %%a in (..\log.txt) do echo %~n1.jar合并失败 >>%%a
goto end ) 
del %1 /Q
rd out /Q /S
echo     正在将 %~n1.jar 与 classes.dex 合并...
cd framework
zip %~n1.jar -u classes.dex>nul
del classes.dex /Q
cd ..\..\
echo.
echo     ---- %~n1.jar合并成功 ---- 
echo.
for %%a in (.\log.txt) do echo %~n1.jar合并成功 >>%%a
goto end

:end