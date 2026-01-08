 @echo off
setlocal enabledelayedexpansion

:: 设置颜色代码
set "colorDefault=07"  :: 默认颜色（白色）
set "colorSuccess=0A"  :: 成功提示（绿色）

:: 获取脚本所在路径作为项目根目录
set "projectRoot=%~dp0"
echo Project root: %projectRoot%

:: 定义要删除的文件夹名称
set "foldersToDelete=bin obj node_modules"

:: 定义要删除的文件模式
set "filesToDelete=*.pdb *.bak *.tmp *.log"

:: 删除指定的文件夹
echo Deleting folders...
for %%f in (%foldersToDelete%) do (
    for /d /r "%projectRoot%" %%d in (%%f) do (
        if exist "%%d" (
            color %colorSuccess%
            echo Deleting folder: %%d
            rmdir /s /q "%%d"
            color %colorDefault%
        )
    )
)

:: 删除指定的文件
echo Deleting files...
for %%f in (%filesToDelete%) do (
    for /r "%projectRoot%" %%d in (%%f) do (
        if exist "%%d" (
            echo Deleting file: %%d
            del /f /q "%%d"
        )
    )
)

echo Cleanup completed.
pause
