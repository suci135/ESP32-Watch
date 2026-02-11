@echo off
chcp 65001 >nul
echo ====================================
echo ESP32-Watch GitHub 上传脚本
echo ====================================
echo.

REM 配置Git用户信息
echo [配置] 设置Git用户信息...
git config user.name "Suci"
git config user.email "3314881686@qq.com"
echo Git用户配置完成
echo.

REM 检查是否已经初始化Git仓库
if not exist ".git" (
    echo [步骤 1/6] 初始化Git仓库...
    git init
    echo Git仓库初始化完成
    echo.
) else (
    echo [步骤 1/6] Git仓库已存在，跳过初始化
    echo.
)

REM 检查是否已添加远程仓库
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo [步骤 2/6] 添加远程仓库...
    git remote add origin https://github.com/suci135/ESP32-Watch.git
    echo 远程仓库添加完成
    echo.
) else (
    echo [步骤 2/6] 远程仓库已存在
    for /f "delims=" %%i in ('git remote get-url origin') do set CURRENT_REMOTE=%%i
    echo 当前远程仓库: %CURRENT_REMOTE%
    echo.
    
    REM 如果远程仓库地址不正确，更新它
    if not "%CURRENT_REMOTE%"=="https://github.com/suci135/ESP32-Watch.git" (
        echo 更新远程仓库地址...
        git remote set-url origin https://github.com/suci135/ESP32-Watch.git
        echo 远程仓库地址已更新
        echo.
    )
)

REM 添加所有文件
echo [步骤 3/6] 添加文件到暂存区...
git add .
echo 文件添加完成
echo.

REM 提交更改
echo [步骤 4/6] 提交更改...
set /p COMMIT_MSG="请输入提交信息 (直接回车使用默认信息): "
if "%COMMIT_MSG%"=="" (
    set COMMIT_MSG=Update project files
)
git commit -m "%COMMIT_MSG%"
echo 提交完成
echo.

REM 获取当前分支名
for /f "delims=" %%i in ('git branch --show-current') do set CURRENT_BRANCH=%%i
if "%CURRENT_BRANCH%"=="" (
    set CURRENT_BRANCH=main
    echo [步骤 5/6] 设置默认分支为 main...
    git branch -M main
    echo.
) else (
    echo [步骤 5/6] 当前分支: %CURRENT_BRANCH%
    echo.
)

REM 推送到GitHub
echo [步骤 6/6] 推送到GitHub...
echo 正在推送到远程仓库...
git push -u origin %CURRENT_BRANCH%

if errorlevel 1 (
    echo.
    echo ====================================
    echo 推送失败！
    echo ====================================
    echo.
    echo 可能的原因：
    echo 1. 需要先在GitHub上创建仓库
    echo 2. 需要配置Git凭据
    echo 3. 网络连接问题
    echo.
    echo 如果是首次推送，请确保：
    echo - 已在GitHub创建 ESP32-Watch 仓库
    echo - 已配置Git用户名和邮箱：
    echo   git config --global user.name "你的用户名"
    echo   git config --global user.email "你的邮箱"
    echo.
    pause
    exit /b 1
) else (
    echo.
    echo ====================================
    echo 上传成功！
    echo ====================================
    echo.
    echo 项目已成功推送到：
    echo https://github.com/suci135/ESP32-Watch
    echo.
)

pause
