import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/models/page_models.dart';
import 'package:luna_arc_sync/data/repositories/page_repository.dart';
import 'version_history_state.dart';

@injectable
class VersionHistoryCubit extends Cubit<VersionHistoryState> {
  final IPageRepository _pageRepository;

  VersionHistoryCubit(this._pageRepository) : super(const VersionHistoryState.initial());

  Future<void> fetchHistory(String pageId) async {
    emit(const VersionHistoryState.loading());
    try {
      // 为了获取当前版本信息，并行获取版本历史和页面详情
      final results = await Future.wait([
        _pageRepository.getVersionHistory(pageId),
        _pageRepository.getPageById(pageId),
      ]);
      final versions = results[0] as List<PageVersion>;
      final pageDetail = results[1] as PageDetail;

      emit(VersionHistoryState.success(
        versions: versions.reversed.toList(),
        currentpageId: pageId,
        currentVersionId: pageDetail.currentVersion?.versionId,
      ));
    } catch (e) {
      emit(VersionHistoryState.failure(message: e.toString()));
    }
  }

  // --- START: NEW REVERT METHOD ---

  Future<void> revertToVersion(String targetVersionId) async {
    // 使用 state.whenOrNull 确保只有在 success 状态下才能执行回滚
    await state.whenOrNull(
      success: (versions, pageId, currentVersionId) async {
        try {
          // **修正**: 调用 repository 的 revertToVersion 方法。
          // 根据错误提示，此方法返回 void，因此我们无法直接使用其返回值。
          await _pageRepository.revertToVersion(
            pageId: pageId,
            targetVersionId: targetVersionId,
          );
          
          // **说明**: 由于无法从 repository 层直接获取更新后的版本号，
          // 我们必须在回滚操作成功后重新获取整个版本历史和页面详情，
          // 以确保 UI 正确反映出哪个版本是“Current”。
          await fetchHistory(pageId);

        } catch (e) {
          // 如果回滚失败，将异常重新抛出
          rethrow;
        }
      },
    );
  }
  // --- END: NEW REVERT METHOD ---
}