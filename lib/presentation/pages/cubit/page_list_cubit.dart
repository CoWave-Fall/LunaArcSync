import 'dart:async';
import 'dart:typed_data'; // 导入以使用 Uint8List
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/repositories/page_repository.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_list_state.dart';

@injectable
class PageListCubit extends Cubit<PageListState> {
  final IPageRepository _pageRepository;

  PageListCubit(this._pageRepository) : super(const PageListState());

  Future<void> fetchPages() async {
    if (state.status == PageListStatus.loading) return;

    emit(state.copyWith(status: PageListStatus.loading));

    try {
      final result = await _pageRepository.getPages(pageNumber: 1);
      emit(state.copyWith(
        status: PageListStatus.success,
        pages: result.items,
        pageNumber: 1,
        hasReachedMax: !result.hasNextPage,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PageListStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> fetchNextPage() async {
    if (state.hasReachedMax || state.status == PageListStatus.loadingMore) return;

    emit(state.copyWith(status: PageListStatus.loadingMore));

    try {
      final nextPage = state.pageNumber + 1;
      final result = await _pageRepository.getPages(pageNumber: nextPage);

      emit(state.copyWith(
        status: PageListStatus.success,
        pages: List.of(state.pages)..addAll(result.items),
        pageNumber: nextPage,
        hasReachedMax: !result.hasNextPage,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: PageListStatus.success, errorMessage: e.toString()));
    }
  }

  Future<void> createPage({
    required String title,
    required Uint8List fileBytes, // 修改：使用字节数组
    required String fileName,      // 新增：需要文件名
  }) async {
    try {
      await _pageRepository.createPage(
        title: title,
        fileBytes: fileBytes,
        fileName: fileName,
      );
      // 创建成功后，重新从第一页加载数据
      await fetchPages();
    } catch (e) {
      // 将异常重新抛出，让 UI 层可以捕获并显示错误信息
      rethrow;
    }
  }

  Future<void> fetchUnassignedPages() async {
    if (state.status == PageListStatus.loading) return;

    emit(state.copyWith(status: PageListStatus.loading));

    try {
      final pages = await _pageRepository.getUnassignedPages();
      emit(state.copyWith(
        status: PageListStatus.success,
        pages: pages,
        pageNumber: 1, // Not really paginated, but set to 1
        hasReachedMax: true, // No more pages to load
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PageListStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}