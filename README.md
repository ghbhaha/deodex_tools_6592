说明

deodex工具(6592适用) 

使用方法介绍

1.获取你要合并的ROM的/system/app和/system/framework目录，复制到工具箱/system目录下

2.双击start.bat 

3.你可以选择合并app目录，framework目录或者两个目录都合并

3.若正常开机则deodex完成

合并过程中报错或者合并后不能开机

方案一：修改tools/use_this_version.txt 中的版本号

方案二：连接手机，运行fix_error.bat 提取获取你的ROM的fix_error文件拷贝至tools文件夹

感谢wuxianlin 的6592合并工具开源项目 https://github.com/wuxianlin/deodex_tools/tree/mt6592 

感谢smali开源项目 google code github