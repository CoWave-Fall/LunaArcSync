# LunaArcSync 图标生成脚本
# 使用 ImageMagick 从 logo.svg 生成所有平台的图标

param(
    [string]$ImageMagickPath = "C:\Program Files\ImageMagick-7.1.2-Q16-HDRI\magick.exe",
    [string]$SourceFile = "assets\images\logo.svg"
)

Write-Host "🎨 LunaArcSync 图标生成脚本" -ForegroundColor Cyan
Write-Host "源文件: $SourceFile" -ForegroundColor Yellow
Write-Host "ImageMagick 路径: $ImageMagickPath" -ForegroundColor Yellow
Write-Host ""

# 检查源文件是否存在
if (-not (Test-Path $SourceFile)) {
    Write-Error "❌ 源文件不存在: $SourceFile"
    exit 1
}

# 检查 ImageMagick 是否存在
if (-not (Test-Path $ImageMagickPath)) {
    Write-Error "❌ ImageMagick 不存在: $ImageMagickPath"
    exit 1
}

Write-Host "✅ 开始生成图标..." -ForegroundColor Green

# Android 平台图标
Write-Host "📱 生成 Android 图标..." -ForegroundColor Blue
$androidSizes = @{
    "mipmap-mdpi" = 48
    "mipmap-hdpi" = 72
    "mipmap-xhdpi" = 96
    "mipmap-xxhdpi" = 144
    "mipmap-xxxhdpi" = 192
}

foreach ($density in $androidSizes.Keys) {
    $size = $androidSizes[$density]
    $outputPath = "android\app\src\main\res\$density\ic_launcher.png"
    
    # 确保目录存在
    $dir = Split-Path $outputPath -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    
    & $ImageMagickPath $SourceFile -resize "${size}x${size}" $outputPath
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✅ $density (${size}x${size})" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $density (${size}x${size})" -ForegroundColor Red
    }
}

# iOS 平台图标
Write-Host "🍎 生成 iOS 图标..." -ForegroundColor Blue
$iosIcons = @{
    "Icon-App-20x20@1x.png" = 20
    "Icon-App-20x20@2x.png" = 40
    "Icon-App-20x20@3x.png" = 60
    "Icon-App-29x29@1x.png" = 29
    "Icon-App-29x29@2x.png" = 58
    "Icon-App-29x29@3x.png" = 87
    "Icon-App-40x40@1x.png" = 40
    "Icon-App-40x40@2x.png" = 80
    "Icon-App-40x40@3x.png" = 120
    "Icon-App-60x60@2x.png" = 120
    "Icon-App-60x60@3x.png" = 180
    "Icon-App-76x76@1x.png" = 76
    "Icon-App-76x76@2x.png" = 152
    "Icon-App-83.5x83.5@2x.png" = 167
    "Icon-App-1024x1024@1x.png" = 1024
}

$iosDir = "ios\Runner\Assets.xcassets\AppIcon.appiconset"
if (-not (Test-Path $iosDir)) {
    New-Item -ItemType Directory -Path $iosDir -Force | Out-Null
}

foreach ($icon in $iosIcons.Keys) {
    $size = $iosIcons[$icon]
    $outputPath = "$iosDir\$icon"
    
    & $ImageMagickPath $SourceFile -resize "${size}x${size}" $outputPath
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✅ $icon (${size}x${size})" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $icon (${size}x${size})" -ForegroundColor Red
    }
}

# Web 平台图标
Write-Host "🌐 生成 Web 图标..." -ForegroundColor Blue
$webIcons = @{
    "Icon-192.png" = 192
    "Icon-512.png" = 512
    "Icon-maskable-192.png" = 192
    "Icon-maskable-512.png" = 512
}

$webDir = "web\icons"
if (-not (Test-Path $webDir)) {
    New-Item -ItemType Directory -Path $webDir -Force | Out-Null
}

foreach ($icon in $webIcons.Keys) {
    $size = $webIcons[$icon]
    $outputPath = "$webDir\$icon"
    
    & $ImageMagickPath $SourceFile -resize "${size}x${size}" $outputPath
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✅ $icon (${size}x${size})" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $icon (${size}x${size})" -ForegroundColor Red
    }
}

# Windows 平台图标
Write-Host "🪟 生成 Windows 图标..." -ForegroundColor Blue
$windowsDir = "windows\runner\resources"
if (-not (Test-Path $windowsDir)) {
    New-Item -ItemType Directory -Path $windowsDir -Force | Out-Null
}

$outputPath = "$windowsDir\app_icon.ico"
& $ImageMagickPath $SourceFile -resize "256x256" $outputPath
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✅ app_icon.ico (256x256)" -ForegroundColor Green
} else {
    Write-Host "  ❌ app_icon.ico (256x256)" -ForegroundColor Red
}

# Linux 平台图标 (如果存在)
Write-Host "🐧 生成 Linux 图标..." -ForegroundColor Blue
$linuxDir = "linux\runner\resources"
if (Test-Path $linuxDir) {
    $outputPath = "$linuxDir\app_icon.png"
    & $ImageMagickPath $SourceFile -resize "256x256" $outputPath
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✅ app_icon.png (256x256)" -ForegroundColor Green
    } else {
        Write-Host "  ❌ app_icon.png (256x256)" -ForegroundColor Red
    }
} else {
    Write-Host "  ⚠️  Linux 目录不存在，跳过" -ForegroundColor Yellow
}

# macOS 平台图标 (如果存在)
Write-Host "🍎 生成 macOS 图标..." -ForegroundColor Blue
$macosDir = "macos\Runner\Resources"
if (Test-Path $macosDir) {
    $outputPath = "$macosDir\AppIcon.icns"
    # 先生成不同尺寸的PNG，然后转换为ICNS
    $tempDir = "temp_icons"
    if (-not (Test-Path $tempDir)) {
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    }
    
    # 生成不同尺寸的PNG
    $macosSizes = @(16, 32, 64, 128, 256, 512, 1024)
    foreach ($size in $macosSizes) {
        $tempFile = "$tempDir\icon_${size}.png"
        & $ImageMagickPath $SourceFile -resize "${size}x${size}" $tempFile
    }
    
    # 转换为ICNS
    & $ImageMagickPath "$tempDir\icon_*.png" $outputPath
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✅ AppIcon.icns" -ForegroundColor Green
    } else {
        Write-Host "  ❌ AppIcon.icns" -ForegroundColor Red
    }
    
    # 清理临时文件
    Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "  ⚠️  macOS 目录不存在，跳过" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎉 图标生成完成！" -ForegroundColor Green
Write-Host ""
Write-Host "📊 生成统计:" -ForegroundColor Cyan
Write-Host "  📱 Android: 5 个图标" -ForegroundColor White
Write-Host "  🍎 iOS: 15 个图标" -ForegroundColor White
Write-Host "  🌐 Web: 4 个图标" -ForegroundColor White
Write-Host "  🪟 Windows: 1 个图标" -ForegroundColor White
Write-Host "  🐧 Linux: 1 个图标 (如果存在)" -ForegroundColor White
Write-Host "  🍎 macOS: 1 个图标 (如果存在)" -ForegroundColor White
Write-Host ""
Write-Host "💡 提示: 运行 'flutter clean' 和 'flutter pub get' 以确保更改生效" -ForegroundColor Yellow
