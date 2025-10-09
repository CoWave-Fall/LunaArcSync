import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luna_arc_sync/data/models/page_models.dart';

part 'version_history_state.freezed.dart';

// 使用 @freezed 注解
@freezed
class VersionHistoryState with _$VersionHistoryState {
  // 定义私有构造函数
  const VersionHistoryState._();

  // 定义各个状态的工厂构造函数
  const factory VersionHistoryState.initial() = _Initial;
  const factory VersionHistoryState.loading() = _Loading;
  const factory VersionHistoryState.success({
    required List<PageVersion> versions,
    required String currentpageId,
    String? currentVersionId,
  }) = _Success;
  const factory VersionHistoryState.failure({
    required String message,
  }) = _Failure;
}