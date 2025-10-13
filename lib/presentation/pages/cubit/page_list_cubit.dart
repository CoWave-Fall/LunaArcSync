import 'dart:async';
import 'dart:typed_data'; // 导入以使用 Uint8List
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/repositories/page_repository.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/page_list_state.dart';

@injectable
class PageListCubit extends Cubit<PageListState> {
  final IPageRepository _pageRepository;
  
  // 添加请求管理，防止并发请求导致顺序错误
  final Set<int> _loadingPages = {};

  PageListCubit(this._pageRepository) : super(const PageListState());

  Future<void> fetchPages() async {
    if (state.status == PageListStatus.loading) return;

    // 重置分页状态
    _loadingPages.clear();

    emit(state.copyWith(status: PageListStatus.loading));

    try {
      // 直接获取所有页面，不再使用分页
      final allPages = await _pageRepository.getAllPages();
      emit(state.copyWith(
        status: PageListStatus.success,
        pages: allPages,
        pageNumber: 1,
        hasReachedMax: true, // 已经获取了所有数据
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PageListStatus.failure,
        errorMessage: e.toString(),
      ));
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

    // 重置分页状态
    _loadingPages.clear();

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