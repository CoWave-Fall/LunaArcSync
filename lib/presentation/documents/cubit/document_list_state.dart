import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luna_arc_sync/data/models/document_models.dart';

part 'document_list_state.freezed.dart';

// --- START: NEW SORTING AND FILTERING ---

/// Defines the available sorting options for the document list.
enum SortOption {
  dateDesc('Newest First', 'date_desc'),
  dateAsc('Oldest First', 'date_asc'),
  titleAsc('Title (A-Z)', 'title_asc'),
  titleDesc('Title (Z-A)', 'title_desc');

  const SortOption(this.displayName, this.apiValue);
  final String displayName;
  final String apiValue;
}

// --- END: NEW SORTING AND FILTERING ---


@freezed
abstract class DocumentListState with _$DocumentListState {
  const factory DocumentListState({
    // Core list properties
    @Default([]) List<Document> documents,
    @Default(false) bool isLoading,
    @Default(null) String? error,
    @Default(1) int pageNumber,
    @Default(false) bool hasReachedMax,

    // --- START: NEW SORTING AND FILTERING STATE ---

    // Sorting
    @Default(SortOption.dateDesc) SortOption sortOption,

    // Tag Filtering
    @Default([]) List<String> selectedTags,
    @Default([]) List<String> allTags,
    @Default(false) bool areTagsLoading,
    @Default(null) String? tagsError,
    
    // --- END: NEW SORTING AND FILTERING STATE ---

  }) = _DocumentListState;
}
