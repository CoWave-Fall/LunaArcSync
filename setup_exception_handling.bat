@echo off
REM 服务器意外离线异常处理系统 - 安装脚本 (Windows)
REM 此脚本将自动安装依赖并生成必要的代码

echo ================================================
echo   服务器意外离线异常处理系统 - 安装向导
echo ================================================
echo.

REM 1. 安装依赖
echo 步骤 1/3: 安装依赖...
call flutter pub get

if %errorlevel% neq 0 (
    echo ❌ 安装依赖失败！
    pause
    exit /b 1
)

echo ✅ 依赖安装成功
echo.

REM 2. 生成代码
echo 步骤 2/3: 生成依赖注入代码...
call flutter pub run build_runner build --delete-conflicting-outputs

if %errorlevel% neq 0 (
    echo ❌ 代码生成失败！
    pause
    exit /b 1
)

echo ✅ 代码生成成功
echo.

REM 3. 生成国际化文件
echo 步骤 3/3: 生成国际化文件...
call flutter gen-l10n

if %errorlevel% neq 0 (
    echo ⚠️  国际化文件生成失败，但不影响主要功能
) else (
    echo ✅ 国际化文件生成成功
)

echo.
echo ================================================
echo   ✅ 安装完成！
echo ================================================
echo.
echo 下一步：
echo 1. 查看文档：
echo    - SERVER_OFFLINE_EXCEPTION_HANDLING.md (完整功能文档)
echo    - Docs\DevRef\EXCEPTION_HANDLING_MIGRATION_GUIDE.md (迁移指南)
echo.
echo 2. 迁移现有代码：
echo    - 更新 Repository 使用 NetworkException
echo    - 更新 Cubit 注入 GlobalErrorHandler
echo    - 更新 UI 使用 ErrorDisplayWidget
echo.
echo 3. 测试场景：
echo    - 服务器完全离线
echo    - 网络断开/恢复
echo    - 认证失败
echo    - 慢速网络
echo.
echo 如需帮助，请查看迁移指南或提交 Issue
echo.
pause

