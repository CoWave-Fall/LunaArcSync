import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luna_arc_sync/core/scanner/scanner_service.dart';
import 'package:luna_arc_sync/core/scanner/scanner_config_service.dart';

part 'scanner_management_state.freezed.dart';

@freezed
class ScannerManagementState with _$ScannerManagementState {
  const factory ScannerManagementState.initial() = ScannerManagementInitial;
  
  const factory ScannerManagementState.loading() = ScannerManagementLoading;
  
  const factory ScannerManagementState.discovering(
    List<SavedScannerConfig> savedScanners,
  ) = ScannerManagementDiscovering;
  
  const factory ScannerManagementState.loaded({
    required List<SavedScannerConfig> savedScanners,
    required List<ScannerInfo> discoveredScanners,
  }) = ScannerManagementLoaded;
  
  const factory ScannerManagementState.error(String message) = ScannerManagementError;
}


