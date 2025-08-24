import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';
import 'package:luna_arc_sync/data/repositories/document_repository.dart';
import 'document_list_state.dart';

class DocumentListCubit extends Cubit<DocumentListState> {
  final IDocumentRepository _documentRepository;

  DocumentListCubit(this._documentRepository) : super(const DocumentListState());

  Future<void> fetchDocuments({bool isRefresh = false}) async {
    if (state.isLoading || (state.hasReachedMax && !isRefresh)) return;

    // When refreshing, reset the documents list and page number
    final initialState = isRefresh
        ? state.copyWith(documents: [], pageNumber: 1, hasReachedMax: false)
        : state;

    emit(initialState.copyWith(isLoading: true, error: null));

    // Use the page number from the (potentially reset) state
    final pageNumber = initialState.pageNumber;

    try {
      final result = await _documentRepository.getDocuments(
        pageNumber: pageNumber,
        sortBy: state.sortOption.apiValue,
        tags: state.selectedTags.isNotEmpty ? state.selectedTags : null,
      );

      final newDocuments = result.items;
      final hasReachedMax = result.hasNextPage == false;

      emit(state.copyWith(
        documents: isRefresh ? newDocuments : [...state.documents, ...newDocuments],
        pageNumber: pageNumber + 1,
        hasReachedMax: hasReachedMax,
        isLoading: false,
      ));
    } on DioError catch (e) {
      if (e.response?.statusCode == 503) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Service is temporarily unavailable. Please try again later.',
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: e.message ?? e.toString(),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> fetchAllTags() async {
    emit(state.copyWith(areTagsLoading: true, tagsError: null));
    try {
      final tags = await _documentRepository.getAllTags();
      emit(state.copyWith(allTags: tags, areTagsLoading: false));
    } catch (e) {
      emit(state.copyWith(tagsError: e.toString(), areTagsLoading: false));
    }
  }

  Future<void> changeSort(SortOption sortOption) async {
    if (state.sortOption == sortOption) return;
    emit(state.copyWith(sortOption: sortOption));
    await fetchDocuments(isRefresh: true);
  }

  Future<void> applyTagFilter(List<String> tags) async {
    emit(state.copyWith(selectedTags: tags));
    await fetchDocuments(isRefresh: true);
  }

  void refresh() {
    fetchDocuments(isRefresh: true);
  }
}
