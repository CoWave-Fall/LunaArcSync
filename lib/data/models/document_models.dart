import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luna_arc_sync/core/api/json_converters.dart';
import 'package:luna_arc_sync/data/models/page_models.dart';

part 'document_models.freezed.dart';
part 'document_models.g.dart';

@freezed
class Document with _$Document {
  const factory Document({
    required String documentId,
    required String title,
    @Default([]) List<String> tags,
    @HighPrecisionDateTimeConverter()
    required DateTime createdAt,
    @HighPrecisionDateTimeConverter()
    required DateTime updatedAt,
    @Default(0) int pageCount,
  }) = _Document;

  factory Document.fromJson(Map<String, dynamic> json) => _$DocumentFromJson(json);
}

@freezed
class DocumentDetail with _$DocumentDetail {
  const factory DocumentDetail({
    required String documentId,
    required String title,
    @Default([]) List<String> tags,
    @HighPrecisionDateTimeConverter()
    required DateTime createdAt,
    @HighPrecisionDateTimeConverter()
    required DateTime updatedAt,
    @Default([]) List<Page> pages,
  }) = _DocumentDetail;

  factory DocumentDetail.fromJson(Map<String, dynamic> json) => _$DocumentDetailFromJson(json);
}

@freezed
class DocumentStats with _$DocumentStats {
  const factory DocumentStats({
    required int totalDocuments,
    required int totalPages,
  }) = _DocumentStats;

  factory DocumentStats.fromJson(Map<String, dynamic> json) => _$DocumentStatsFromJson(json);
}