import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_models.freezed.dart';
part 'search_models.g.dart';

enum SearchResultType {
  @JsonValue('document')
  document,
  
  @JsonValue('page')
  page,
}

@freezed
abstract class SearchResultItem with _$SearchResultItem {
  const factory SearchResultItem({
    required SearchResultType type,
    required String documentId,
    required String documentTitle, // Reverted to required
    String? pageId,
    String? pageTitle,           // Reverted to pageTitle
    required String matchSnippet,
  }) = _SearchResultItem;

  factory SearchResultItem.fromJson(Map<String, dynamic> json) =>
      _$SearchResultItemFromJson(json);
}