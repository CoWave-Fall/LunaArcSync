<div align="center">

# 🌙 LunaArcSync

**泠月案阁档案管理系统 - Flutter 客户端**

[![License: GPLv3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.9+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9+-0175C2?logo=dart)](https://dart.dev)

一个跨平台文档管理应用，支持 PDF 渲染、OCR 识别、内容搜索等多种特性。

本项目是[泠月案阁档案管理系统](https://github.com/CoWave-Fall)的 Flutter 客户端实现，配合 [LunaArcSync.API](https://github.com/CoWave-Fall/LunaArcSync.API) 后端服务使用。

[系统架构](#-系统架构) • [功能特性](#-功能特性) • [快速开始](#-快速开始) • [技术架构](#-技术架构) • [开发指南](#-开发指南)

</div>

---

## 🏛️ 系统架构

泠月案阁是一个完整的智能文档档案管理系统，采用前后端分离架构：

- **后端服务**: [LunaArcSync.API](https://github.com/CoWave-Fall/LunaArcSync.API) - 基于 .NET 8 构建的 RESTful API，提供文档存储、版本控制、异步 OCR 处理等核心功能
- **Flutter 客户端**: 本项目 - 跨平台移动端和桌面端应用，支持 Android、iOS、Windows、macOS、Linux 和 Web
- **其他客户端**: 可扩展支持更多平台和技术栈

### 主要特性

- 📡 **RESTful API 集成**：与后端服务无缝对接
- 🔐 **JWT 认证**：安全的用户身份验证
- 📤 **文件上传下载**：支持多种文档格式
- 🔄 **版本管理**：完整的文档版本历史
- 🤖 **OCR 集成**：异步 OCR 处理和结果展示
- 🔍 **全文搜索**：快速查找文档内容

---

## ✨ 功能特性

### 📄 强大的 PDF 支持
- 🎨 **多渲染引擎**：支持 PDFX、PDFRX 和原生三种渲染后端，自动选择最优方案
- 🔍 **高清渲染**：高质量 PDF 页面显示，支持缩放和导航
- 📱 **响应式布局**：完美适配不同屏幕尺寸和设备

### 🔤 OCR 文本识别
- 📸 **文档扫描**：集成智能文档扫描功能
- 🎯 **精确定位**：OCR 文本精确坐标映射和显示
- 🖼️ **可视化覆盖**：文本结果实时覆盖在原始图像上
- ✂️ **图片编辑**：内置图片裁剪和批量编辑功能

### 🔍 智能搜索
- ⚡ **全文搜索**：快速搜索文档和页面内容
- 📝 **搜索历史**：自动保存搜索历史，方便快速访问
- 🎯 **精准匹配**：支持关键词高亮和上下文预览

### 📚 文档管理
- 📂 **文档列表**：清晰的文档组织和展示
- 🏷️ **标签系统**：使用标签对文档进行分类管理
- 📄 **页面管理**：详细的页面级管理和预览
- 🕐 **版本历史**：完整的文档版本历史追踪

### 🌐 多平台支持
- 📱 **移动端**：Android、iOS 原生体验
- 💻 **桌面端**：Windows、macOS、Linux 桌面应用
- 🌍 **Web 端**：浏览器直接访问，无需安装

### 🎨 现代化界面
- 🌓 **主题系统**：优雅的界面设计和流畅动画
- 🌏 **多语言**：完整的中英文本地化支持
- 🎭 **自定义字体**：集成霞鹜文楷等优质字体
- 🖼️ **SVG 支持**：矢量图标和动画效果

### 🔐 安全可靠
- 🔒 **安全存储**：使用 Flutter Secure Storage 保护敏感数据
- 👤 **用户认证**：完整的登录和注册系统
- 🛡️ **数据隔离**：用户数据本地加密存储

### ⚙️ 高级功能
- 📤 **数据传输**：支持数据导入导出
- 🔄 **后台任务**：异步任务管理和进度追踪
- ⚡ **性能优化**：智能缓存和懒加载
- 🎮 **自定义设置**：丰富的个性化配置选项

---

## 🚀 快速开始

### 前置要求

- **Flutter SDK** `>= 3.9.0`
- **Dart SDK** `>= 3.9.0`
- **开发工具**：Android Studio、VS Code 或其他支持 Flutter 的 IDE
- **Git** 用于版本控制

### 安装步骤

1. **克隆项目**
```bash
git clone https://github.com/CoWave-Fall/LunaArcSync.git
cd LunaArcSync
```

2. **安装依赖**
```bash
flutter pub get
```

3. **代码生成**（如需要）
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **运行应用**
```bash
# 开发模式
flutter run

# 指定平台
flutter run -d windows  # Windows
flutter run -d chrome   # Web
flutter run -d android  # Android
```

### 构建发布版本

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Web
flutter build web --release
```

---

## 🏗️ 技术架构

### 核心技术栈

| 技术 | 用途 | 版本 |
|------|------|------|
| **Flutter** | 跨平台 UI 框架 | 3.9+ |
| **Dart** | 编程语言 | 3.9+ |
| **flutter_bloc** | 状态管理 | ^9.1.1 |
| **GetIt** | 依赖注入 | ^8.2.0 |
| **Go Router** | 路由管理 | ^16.2.4 |
| **Dio** | 网络请求 | ^5.4.3 |
| **PDFX / PDFRX** | PDF 渲染 | ^2.7.0 / ^1.0.88 |

### 项目结构

```
lib/
├── core/                           # 核心功能模块
│   ├── api/                        # API 客户端和网络配置
│   ├── config/                     # 应用配置
│   ├── di/                         # 依赖注入设置
│   ├── storage/                    # 本地存储服务
│   └── theme/                      # 主题和样式配置
│
├── data/                           # 数据层
│   ├── models/                     # 数据模型和实体
│   └── repositories/               # 数据仓库实现
│
├── presentation/                   # 表现层（UI）
│   ├── auth/                       # 用户认证（登录/注册）
│   │   ├── cubit/                  # 认证状态管理
│   │   ├── view/                   # 认证页面
│   │   └── widgets/                # 认证相关组件
│   │
│   ├── documents/                  # 文档管理
│   │   ├── cubit/                  # 文档状态管理
│   │   ├── view/                   # 文档列表和详情页
│   │   └── widgets/                # 文档相关组件
│   │
│   ├── pages/                      # 页面管理
│   │   ├── cubit/                  # 页面状态管理
│   │   ├── view/                   # 页面详情和列表
│   │   └── widgets/                # PDF 渲染器、OCR 覆盖层等
│   │
│   ├── search/                     # 搜索功能
│   ├── settings/                   # 设置和配置
│   ├── jobs/                       # 后台任务管理
│   ├── about/                      # 关于页面
│   ├── shell/                      # 应用外壳和导航
│   └── widgets/                    # 通用 UI 组件
│
├── l10n/                          # 国际化文件
│   ├── app_en.arb                 # 英文翻译
│   ├── app_zh.arb                 # 中文翻译
│   └── ...                        # 自动生成的本地化代码
│
├── app.dart                       # 应用根组件
└── main.dart                      # 应用入口
```

### 架构模式

- **状态管理**：采用 BLoC (Cubit) 模式管理应用状态
- **依赖注入**：使用 GetIt + Injectable 实现依赖注入
- **代码生成**：使用 Freezed 和 JSON Serializable 生成样板代码
- **路由管理**：基于 Go Router 的声明式路由
- **模块化设计**：清晰的分层架构，易于维护和扩展

---

## 💻 开发指南

### 环境配置

1. **安装 Flutter**
   - 访问 [Flutter 官网](https://flutter.dev) 下载并安装
   - 运行 `flutter doctor` 检查环境配置

2. **配置编辑器**
   - **VS Code**：安装 Flutter 和 Dart 扩展
   - **Android Studio**：安装 Flutter 和 Dart 插件

3. **设备准备**
   - Android：启用 USB 调试模式
   - iOS：配置开发者证书
   - Web：使用现代浏览器

### 开发命令

```bash
# 查看可用设备
flutter devices

# 热重载开发
flutter run

# 代码生成
flutter pub run build_runner build

# 监听模式代码生成
flutter pub run build_runner watch

# 代码分析
flutter analyze

# 运行测试
flutter test

# 清理构建缓存
flutter clean
```

### 本地化

本项目支持完整的中英文本地化。添加新的翻译：

1. 编辑 `lib/l10n/app_en.arb` 和 `lib/l10n/app_zh.arb`
2. 运行 `flutter pub get` 自动生成本地化代码
3. 使用 `AppLocalizations.of(context)!.yourKey` 访问翻译

### 代码规范

- 遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart) 规范
- 使用 `flutter analyze` 检查代码质量
- 提交前确保没有 lint 错误

---

## 📦 主要依赖

### UI 和交互
- **flutter_svg**: SVG 图像支持
- **image_cropper**: 图片裁剪功能
- **file_picker**: 文件选择器
- **url_launcher**: URL 启动器

### 数据和存储
- **flutter_secure_storage**: 安全存储
- **shared_preferences**: 本地配置存储
- **path_provider**: 文件路径管理

### PDF 和文档
- **pdfx**: PDF 渲染引擎（MIT）
- **pdfrx**: 现代 PDF 渲染（MIT）
- **flutter_inappwebview**: PDF.js 后端支持（Apache 2.0）
- **cunning_document_scanner**: 文档扫描

### 网络和数据处理
- **dio**: HTTP 客户端
- **json_annotation**: JSON 序列化

### 开发工具
- **build_runner**: 代码生成器
- **freezed**: 数据类生成
- **injectable_generator**: 依赖注入生成

---

## 🤝 贡献指南

欢迎贡献代码、报告问题或提出建议！

### 贡献流程

1. **Fork 项目** 到你的 GitHub 账号
2. **创建特性分支** (`git checkout -b feature/AmazingFeature`)
3. **提交更改** (`git commit -m '添加某个很棒的功能'`)
4. **推送到分支** (`git push origin feature/AmazingFeature`)
5. **创建 Pull Request**

### 提交规范

- `feat`: 新功能
- `fix`: 修复 Bug
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建或辅助工具变动

---

## 📄 许可证

本项目采用 **GNU General Public License v3.0** 开源许可证。

这意味着：
- ✅ 可以自由使用、修改和分发
- ✅ 可以用于商业目的
- ⚠️ 必须开源衍生作品
- ⚠️ 必须使用相同的 GPLv3 许可证
- ⚠️ 必须声明修改内容

详情请查看 [LICENSE](LICENSE) 文件。

---

## 📞 联系方式

- **问题反馈**：[GitHub Issues](https://github.com/CoWave-Fall/LunaArcSync/issues)
- **功能建议**：[GitHub Discussions](https://github.com/CoWave-Fall/LunaArcSync/discussions)
- **后端项目**：[LunaArcSync.API](https://github.com/CoWave-Fall/LunaArcSync.API)

---

## 🤖 生成式 AI 内容声明

本项目在开发过程中使用了生成式 AI 工具辅助完成部分内容，包括但不限于：

- 📝 **文档编写**：部分 README、代码注释和技术文档由 AI 辅助撰写和优化
- 💬 **用户界面文本**：部分 UI 文本、提示信息和本地化内容由 AI 辅助生成
- 🎨 **设计建议**：部分 UI/UX 设计方案和代码结构由 AI 提供建议
- 🔧 **代码优化**：部分代码片段在 AI 辅助下进行了优化和重构


## 🙏 致谢

感谢所有开源项目和贡献者，特别是：

- [Flutter](https://flutter.dev) 团队
- [flutter_bloc](https://bloclibrary.dev) 社区
- [PDFX](https://pub.dev/packages/pdfx) 和 [PDFRX](https://pub.dev/packages/pdfrx) 作者
- Google Gemini、Claude、DeepSeek 等生成式 AI 工具在开发过程中提供的帮助
- 所有依赖库的维护者

