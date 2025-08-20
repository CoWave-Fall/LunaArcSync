import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luna_arc_sync/core/api/json_converters.dart';

part 'page_models.freezed.dart';
part 'page_models.g.dart';

// Model for a single page item in the list
@freezed
class Page with _$Page {
  const factory Page({
    required String pageId,
    required String title,
    @HighPrecisionDateTimeConverter()
    required DateTime createdAt,
    @HighPrecisionDateTimeConverter()
    required DateTime updatedAt,
    @Default(0) int order, // 新增 order 字段
  }) = _Page;

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
}


// A generic model for paginated API responses
@JsonSerializable(genericArgumentFactories: true)
class PaginatedResult<T> {
  final List<T> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  PaginatedResult({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory PaginatedResult.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PaginatedResultFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedResultToJson(this, toJsonT);
}

// --- START: OCR DATA MODELS ---
// (确保旧的 OcrResult 定义已完全被以下内容替换)

@freezed
class Bbox with _$Bbox {
  const factory Bbox({
    required int x1,
    required int y1,
    required int x2,
    required int y2,
  }) = _Bbox;

  factory Bbox.fromJson(Map<String, dynamic> json) => _$BboxFromJson(json);
}

@freezed
class OcrWord with _$OcrWord {
  const factory OcrWord({
    required String text,
    required Bbox bbox,
    required double confidence,
  }) = _OcrWord;

  factory OcrWord.fromJson(Map<String, dynamic> json) => _$OcrWordFromJson(json);
}

@freezed
class OcrLine with _$OcrLine {
  const factory OcrLine({
    required List<OcrWord> words,
    required String text,
    required Bbox bbox,
  }) = _OcrLine;

  factory OcrLine.fromJson(Map<String, dynamic> json) => _$OcrLineFromJson(json);
}

@freezed
class OcrResult with _$OcrResult {
  const factory OcrResult({
    required List<OcrLine> lines,
    required int imageWidth,
    required int imageHeight,
  }) = _OcrResult;
  
  factory OcrResult.fromJson(Map<String, dynamic> json) => _$OcrResultFromJson(json);
}

// --- END: OCR DATA MODELS ---

@freezed
class PageVersion with _$PageVersion {
  const factory PageVersion({
    required String versionId,
    required int versionNumber,
    String? message,
    @HighPrecisionDateTimeConverter()
    required DateTime createdAt,
    OcrResult? ocrResult,
  }) = _PageVersion;

  factory PageVersion.fromJson(Map<String, dynamic> json) => _$PageVersionFromJson(json);
}

@freezed
class PageDetail with _$PageDetail {
  const factory PageDetail({
    required String pageId,
    required String title,
    @HighPrecisionDateTimeConverter()
    required DateTime createdAt,
    @HighPrecisionDateTimeConverter()
    required DateTime updatedAt,
    required PageVersion currentVersion,
    required int totalVersions,
  }) = _PageDetail;

  factory PageDetail.fromJson(Map<String, dynamic> json) => _$PageDetailFromJson(json);
}
