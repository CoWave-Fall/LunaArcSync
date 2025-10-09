import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_transfer_state.freezed.dart';

@freezed
abstract class DataTransferState with _$DataTransferState {
  const factory DataTransferState.initial() = _Initial;
  const factory DataTransferState.loading(String message) = _Loading;
  const factory DataTransferState.exportSuccess(Uint8List data) = _ExportSuccess;
  const factory DataTransferState.importSuccess() = _ImportSuccess;
  const factory DataTransferState.failure(String error) = _Failure;
}
