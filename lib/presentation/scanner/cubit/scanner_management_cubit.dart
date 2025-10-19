import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/scanner/scanner_manager.dart';
import 'package:luna_arc_sync/core/scanner/scanner_service.dart';
import 'package:luna_arc_sync/core/scanner/scanner_config_service.dart';
import 'scanner_management_state.dart';

@injectable
class ScannerManagementCubit extends Cubit<ScannerManagementState> {
  final ScannerManager _scannerManager;
  final ScannerConfigService _configService;
  
  ScannerManagementCubit(
    this._scannerManager,
    this._configService,
  ) : super(const ScannerManagementState.initial());
  
  /// 加载已保存的扫描仪
  Future<void> loadSavedScanners() async {
    emit(const ScannerManagementState.loading());
    
    try {
      final savedScanners = _configService.getSavedScanners();
      emit(ScannerManagementState.loaded(
        savedScanners: savedScanners,
        discoveredScanners: [],
      ));
    } catch (e) {
      emit(ScannerManagementState.error(e.toString()));
    }
  }
  
  /// 发现可用扫描仪
  Future<void> discoverScanners() async {
    final currentState = state;
    final savedScanners = currentState is ScannerManagementLoaded
        ? currentState.savedScanners
        : _configService.getSavedScanners();
    
    emit(ScannerManagementState.discovering(savedScanners));
    
    try {
      final discoveredScanners = await _scannerManager.discoverAllScanners();
      emit(ScannerManagementState.loaded(
        savedScanners: savedScanners,
        discoveredScanners: discoveredScanners,
      ));
    } catch (e) {
      emit(ScannerManagementState.error(e.toString()));
    }
  }
  
  /// 保存扫描仪配置
  Future<void> saveScannerConfig(SavedScannerConfig config) async {
    try {
      await _configService.saveScannerConfig(config);
      await loadSavedScanners();
    } catch (e) {
      emit(ScannerManagementState.error(e.toString()));
    }
  }
  
  /// 删除扫描仪配置
  Future<void> removeScannerConfig(String scannerId) async {
    try {
      await _configService.removeScannerConfig(scannerId);
      await loadSavedScanners();
    } catch (e) {
      emit(ScannerManagementState.error(e.toString()));
    }
  }
  
  /// 设置默认扫描仪
  Future<void> setDefaultScanner(String scannerId) async {
    try {
      await _configService.setDefaultScanner(scannerId);
      await loadSavedScanners();
    } catch (e) {
      emit(ScannerManagementState.error(e.toString()));
    }
  }
  
  /// 更新扫描仪配置
  Future<void> updateScannerConfig({
    required String scannerId,
    String? name,
    int? defaultDpi,
    String? defaultColorMode,
    bool? defaultAdf,
  }) async {
    try {
      final config = _configService.getScannerConfig(scannerId);
      if (config != null) {
        final updatedConfig = config.copyWith(
          name: name,
          defaultDpi: defaultDpi,
          defaultColorMode: defaultColorMode,
          defaultAdf: defaultAdf,
        );
        await _configService.saveScannerConfig(updatedConfig);
        await loadSavedScanners();
      }
    } catch (e) {
      emit(ScannerManagementState.error(e.toString()));
    }
  }
  
  /// 从发现的扫描仪添加到已保存列表
  Future<void> addDiscoveredScanner(ScannerInfo scanner) async {
    try {
      final config = SavedScannerConfig.fromScannerInfo(scanner);
      await _configService.saveScannerConfig(config);
      await loadSavedScanners();
    } catch (e) {
      emit(ScannerManagementState.error(e.toString()));
    }
  }
}


