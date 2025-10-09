import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/repositories/document_repository.dart';
import 'document_list_state.dart';

@injectable
class DocumentListCubit extends Cubit<DocumentListState> {
  final IDocumentRepository _documentRepository;

  DocumentListCubit(this._documentRepository) : super(const DocumentListState());

  Future<void> fetchDocuments({bool isRefresh = false}) async {
    if (state.isLoading || (state.hasReachedMax && !isRefresh)) return;

    // When refreshing, reset the documents list and page number
    final initialState = isRefresh
        ? state.copyWith(documents: [], pageNumber: 1, hasReachedMax: false)
        : state;

    if (!isClosed) {
      emit(initialState.copyWith(isLoading: true, error: null));
    }

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

      if (!isClosed) {
        emit(state.copyWith(
          documents: isRefresh ? newDocuments : [...state.documents, ...newDocuments],
          pageNumber: pageNumber + 1,
          hasReachedMax: hasReachedMax,
          isLoading: false,
        ));
      }
    } on DioException catch (e) {
      if (!isClosed) {
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
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          isLoading: false,
          error: e.toString(),
        ));
      }
    }
  }

  Future<void> fetchAllTags() async {
    if (!isClosed) {
      emit(state.copyWith(areTagsLoading: true, tagsError: null));
    }
    try {
      final tags = await _documentRepository.getAllTags();
      if (!isClosed) {
        emit(state.copyWith(allTags: tags, areTagsLoading: false));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(tagsError: e.toString(), areTagsLoading: false));
      }
    }
  }

  Future<void> changeSort(SortOption sortOption) async {
    if (state.sortOption == sortOption) return;
    if (!isClosed) {
      emit(state.copyWith(sortOption: sortOption));
    }
    await fetchDocuments(isRefresh: true);
  }

  Future<void> applyTagFilter(List<String> tags) async {
    if (!isClosed) {
      emit(state.copyWith(selectedTags: tags));
    }
    await fetchDocuments(isRefresh: true);
  }

  Future<void> createDocument(String title) async {
    try {
      // 1. Create the document with the title
      final newDocument = await _documentRepository.createDocument(title);

      // 2. Calculate the default tag
      final now = DateTime.now();
      final year = now.year;
      // Calculate the week of the year manually
      final dayOfYear = now.difference(DateTime(year, 1, 1)).inDays + 1;
      final week = (dayOfYear / 7).ceil();
      final defaultTag = '$year年$week周';

      // 3. Update the newly created document with the default tag
      await _documentRepository.updateDocument(
        documentId: newDocument.documentId,
        title: newDocument.title, // Pass the original title back
        tags: [defaultTag], // Set the tags list with the default tag
      );

      // 4. After creating and updating, refresh the list to show the new document
      await fetchDocuments(isRefresh: true);
    } catch (e) {
      // Optionally, emit a specific error state for creation failure
      if (!isClosed) {
        emit(state.copyWith(error: 'Failed to create document: ${e.toString()}'));
      }
    }
  }

  void refresh() {
    fetchDocuments(isRefresh: true);
  }

  Future<String> startBatchExportJob(List<String> documentIds) async {
    if (documentIds.isEmpty) {
      throw Exception('文档ID列表为空，无法开始批量导出');
    }

    try {
      // 启动批量导出任务，返回jobId
      final jobId = await _documentRepository.startBatchExportJob(documentIds);
      return jobId;
    } catch (e) {
      rethrow;
    }
  }
}
