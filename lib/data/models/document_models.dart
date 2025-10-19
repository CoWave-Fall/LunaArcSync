import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luna_arc_sync/core/api/json_converters.dart';
import 'package:luna_arc_sync/data/models/page_models.dart';
// Import this for JsonSerializable
part 'document_models.freezed.dart';
part 'document_models.g.dart';

@freezed
abstract class Document with _$Document {
  const factory Document({
    required String documentId,
    required String title,
    @Default([]) List<String> tags,
    @UnixTimestampConverter()
    required DateTime createdAt,
    @UnixTimestampConverter()
    required DateTime updatedAt,
    @Default(0) int pageCount,
    String? ownerUserId,
    String? thumbnailUrl,
  }) = _Document;

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      documentId: json['documentId'] as String,
      title: json['title'] as String,
      tags: (json['tags'] as List<dynamic>? ?? []).map((e) => e as String).toList(),
      createdAt: const UnixTimestampConverter().fromJson(json['createdAt'] as int),
      updatedAt: const UnixTimestampConverter().fromJson(json['updatedAt'] as int),
      pageCount: json['pageCount'] as int? ?? 0,
      ownerUserId: json['ownerUserId'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );
  }
}

@freezed
abstract class DocumentDetail with _$DocumentDetail {
  const factory DocumentDetail({
    required String documentId,
    required String title,
    @Default([]) List<String> tags,
    @UnixTimestampConverter()
    required DateTime createdAt,
    @UnixTimestampConverter()
    required DateTime updatedAt,
    @Default([]) List<Page> pages,
  }) = _DocumentDetail;

  factory DocumentDetail.fromJson(Map<String, dynamic> json) {
    return DocumentDetail(
      documentId: json['documentId'] as String,
      title: json['title'] as String,
      tags: (json['tags'] as List<dynamic>? ?? []).map((e) => e as String).toList(),
      createdAt: const UnixTimestampConverter().fromJson(json['createdAt'] as int),
      updatedAt: const UnixTimestampConverter().fromJson(json['updatedAt'] as int),
      pages: (json['pages'] as List<dynamic>? ?? []).map((e) => Page.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

@freezed
abstract class DocumentStats with _$DocumentStats {
  const factory DocumentStats({
    required int totalDocuments,
    required int totalPages,
  }) = _DocumentStats;

  factory DocumentStats.fromJson(Map<String, dynamic> json) {
    return DocumentStats(
      totalDocuments: json['totalDocuments'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}

@JsonSerializable(genericArgumentFactories: true)
class PagedResult<T> {
  final List<T> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  PagedResult({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory PagedResult.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PagedResultFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PagedResultToJson(this, toJsonT);
}
