import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/repositories/page_repository.dart';
import 'version_history_state.dart';

@injectable
class VersionHistoryCubit extends Cubit<VersionHistoryState> {
  final IPageRepository _pageRepository;

  VersionHistoryCubit(this._pageRepository) : super(const VersionHistoryState.initial());

  Future<void> fetchHistory(String pageId) async {
    emit(const VersionHistoryState.loading());
    try {
      final versions = await _pageRepository.getVersionHistory(pageId);
      emit(VersionHistoryState.success(
        versions: versions.reversed.toList(),
        currentpageId: pageId,
      ));
    } catch (e) {
      emit(VersionHistoryState.failure(message: e.toString()));
    }
  }

  // --- START: NEW REVERT METHOD ---

  Future<void> revertToVersion(String targetVersionId) async {
    // 使用 state.whenOrNull 确保只有在 success 状态下才能执行回滚
    await state.whenOrNull(
      success: (versions, pageId) async {
        try {
          // 调用 repository 的方法来执行回滚操作
          await _pageRepository.revertToVersion(
            pageId: pageId,
            targetVersionId: targetVersionId,
          );
          
          // 回滚成功后，必须重新获取最新的版本历史记录
          // 这样 UI 上的 "Current" 标签才会正确更新
          await fetchHistory(pageId);

        } catch (e) {
          // 如果回滚失败，将异常重新抛出
          // UI 层可以捕获这个异常并向用户显示一个 SnackBar 错误提示
          rethrow;
        }
      },
    );
  }
  // --- END: NEW REVERT METHOD ---
}