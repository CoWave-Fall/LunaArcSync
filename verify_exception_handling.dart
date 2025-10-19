import 'dart:io';

/// 验证服务器意外离线异常处理系统集成状态
/// 
/// 运行方式：dart verify_exception_handling.dart
void main() {
  print('═══════════════════════════════════════════════════════════════');
  print('  服务器意外离线异常处理系统 - 集成验证');
  print('═══════════════════════════════════════════════════════════════');
  print('');

  var allPassed = true;
  var passedCount = 0;
  var totalCount = 0;

  // 检查核心文件
  print('📋 检查核心文件...');
  final coreFiles = [
    'lib/core/exceptions/app_exceptions.dart',
    'lib/core/api/error_handler_interceptor.dart',
    'lib/core/services/network_status_service.dart',
    'lib/core/services/global_error_handler.dart',
    'lib/presentation/widgets/error_display_widget.dart',
    'lib/core/di/network_module.dart',
  ];

  for (final file in coreFiles) {
    totalCount++;
    if (File(file).existsSync()) {
      print('   ✅ $file');
      passedCount++;
    } else {
      print('   ❌ $file (缺失)');
      allPassed = false;
    }
  }
  print('');

  // 检查更新的文件
  print('📝 检查已更新的文件...');
  final updatedFiles = [
    'lib/core/api/api_client.dart',
    'pubspec.yaml',
    'lib/l10n/app_en.arb',
    'lib/l10n/app_zh.arb',
  ];

  for (final file in updatedFiles) {
    totalCount++;
    if (File(file).existsSync()) {
      // 检查特定内容
      final content = File(file).readAsStringSync();
      var hasRequiredContent = false;
      
      if (file.contains('api_client.dart')) {
        hasRequiredContent = content.contains('ErrorHandlerInterceptor');
      } else if (file.contains('pubspec.yaml')) {
        hasRequiredContent = content.contains('connectivity_plus');
      } else if (file.contains('app_en.arb') || file.contains('app_zh.arb')) {
        hasRequiredContent = content.contains('networkErrorServerOffline');
      }

      if (hasRequiredContent) {
        print('   ✅ $file (已正确更新)');
        passedCount++;
      } else {
        print('   ⚠️  $file (可能未正确更新)');
      }
    } else {
      print('   ❌ $file (缺失)');
      allPassed = false;
    }
  }
  print('');

  // 检查文档文件
  print('📚 检查文档文件...');
  final docFiles = [
    'SERVER_OFFLINE_EXCEPTION_HANDLING.md',
    'Docs/DevRef/EXCEPTION_HANDLING_MIGRATION_GUIDE.md',
    'SERVER_EXCEPTION_HANDLING_SUMMARY.md',
  ];

  for (final file in docFiles) {
    totalCount++;
    if (File(file).existsSync()) {
      print('   ✅ $file');
      passedCount++;
    } else {
      print('   ⚠️  $file (建议阅读)');
    }
  }
  print('');

  // 检查生成的文件
  print('🔧 检查生成的文件...');
  final generatedFiles = [
    'lib/core/di/injection.config.dart',
    '.dart_tool/flutter_gen/gen_l10n/app_localizations.dart',
  ];

  for (final file in generatedFiles) {
    totalCount++;
    if (File(file).existsSync()) {
      print('   ✅ $file');
      passedCount++;
    } else {
      print('   ⚠️  $file (需要运行代码生成)');
    }
  }
  print('');

  // 检查依赖
  print('📦 检查依赖...');
  totalCount++;
  final pubspecContent = File('pubspec.yaml').readAsStringSync();
  if (pubspecContent.contains('connectivity_plus')) {
    print('   ✅ connectivity_plus 依赖已添加');
    passedCount++;
  } else {
    print('   ❌ connectivity_plus 依赖未添加');
    allPassed = false;
  }
  print('');

  // 总结
  print('═══════════════════════════════════════════════════════════════');
  print('  验证结果: $passedCount/$totalCount 项通过');
  print('═══════════════════════════════════════════════════════════════');
  print('');

  if (allPassed && passedCount >= totalCount * 0.9) {
    print('✅ 集成成功！所有核心组件都已正确安装。');
    print('');
    print('下一步：');
    print('1. 查看文档：SERVER_OFFLINE_EXCEPTION_HANDLING.md');
    print('2. 阅读迁移指南：Docs/DevRef/EXCEPTION_HANDLING_MIGRATION_GUIDE.md');
    print('3. 开始迁移现有代码');
    print('4. 测试各种网络场景');
  } else {
    print('⚠️  集成不完整，请检查缺失的文件。');
    print('');
    print('可能的解决方案：');
    print('1. 运行: flutter pub get');
    print('2. 运行: flutter pub run build_runner build --delete-conflicting-outputs');
    print('3. 运行: flutter gen-l10n');
    print('4. 检查是否有缺失的文件需要创建');
  }
  print('');

  exit(allPassed ? 0 : 1);
}

