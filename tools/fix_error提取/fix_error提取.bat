@echo off
color 1e
echo.
echo 启动adb中。。。。
echo.
adb\adb kill-server
adb\adb start-server
echo.
echo 正在等待手机连接
adb\adb wait-for-device
echo.
echo 正在推送文件
adb\adb push deodexerant /data/local/tmp/
adb\adb shell chmod 755 /data/local/tmp/deodexerant
echo.
echo 正在提取fix_error
adb\adb shell /data/local/tmp/deodexerant > fix_error
echo.
echo 提取完成
echo. 
pause