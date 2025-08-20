// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedResult<T> _$PaginatedResultFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => PaginatedResult<T>(
  items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
  pageNumber: (json['pageNumber'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  hasPreviousPage: json['hasPreviousPage'] as bool,
  hasNextPage: json['hasNextPage'] as bool,
);

Map<String, dynamic> _$PaginatedResultToJson<T>(
  PaginatedResult<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'items': instance.items.map(toJsonT).toList(),
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalCount': instance.totalCount,
  'totalPages': instance.totalPages,
  'hasPreviousPage': instance.hasPreviousPage,
  'hasNextPage': instance.hasNextPage,
};

_$PageImpl _$$PageImplFromJson(Map<String, dynamic> json) => _$PageImpl(
  pageId: json['pageId'] as String,
  title: json['title'] as String,
  createdAt: const HighPrecisionDateTimeConverter().fromJson(
    json['createdAt'] as String,
  ),
  updatedAt: const HighPrecisionDateTimeConverter().fromJson(
    json['updatedAt'] as String,
  ),
  order: (json['order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$PageImplToJson(_$PageImpl instance) =>
    <String, dynamic>{
      'pageId': instance.pageId,
      'title': instance.title,
      'createdAt': const HighPrecisionDateTimeConverter().toJson(
        instance.createdAt,
      ),
      'updatedAt': const HighPrecisionDateTimeConverter().toJson(
        instance.updatedAt,
      ),
      'order': instance.order,
    };

_$BboxImpl _$$BboxImplFromJson(Map<String, dynamic> json) => _$BboxImpl(
  x1: (json['x1'] as num).toInt(),
  y1: (json['y1'] as num).toInt(),
  x2: (json['x2'] as num).toInt(),
  y2: (json['y2'] as num).toInt(),
);

Map<String, dynamic> _$$BboxImplToJson(_$BboxImpl instance) =>
    <String, dynamic>{
      'x1': instance.x1,
      'y1': instance.y1,
      'x2': instance.x2,
      'y2': instance.y2,
    };

_$OcrWordImpl _$$OcrWordImplFromJson(Map<String, dynamic> json) =>
    _$OcrWordImpl(
      text: json['text'] as String,
      bbox: Bbox.fromJson(json['bbox'] as Map<String, dynamic>),
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$$OcrWordImplToJson(_$OcrWordImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'bbox': instance.bbox,
      'confidence': instance.confidence,
    };

_$OcrLineImpl _$$OcrLineImplFromJson(Map<String, dynamic> json) =>
    _$OcrLineImpl(
      words: (json['words'] as List<dynamic>)
          .map((e) => OcrWord.fromJson(e as Map<String, dynamic>))
          .toList(),
      text: json['text'] as String,
      bbox: Bbox.fromJson(json['bbox'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OcrLineImplToJson(_$OcrLineImpl instance) =>
    <String, dynamic>{
      'words': instance.words,
      'text': instance.text,
      'bbox': instance.bbox,
    };

_$OcrResultImpl _$$OcrResultImplFromJson(Map<String, dynamic> json) =>
    _$OcrResultImpl(
      lines: (json['lines'] as List<dynamic>)
          .map((e) => OcrLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageWidth: (json['imageWidth'] as num).toInt(),
      imageHeight: (json['imageHeight'] as num).toInt(),
    );

Map<String, dynamic> _$$OcrResultImplToJson(_$OcrResultImpl instance) =>
    <String, dynamic>{
      'lines': instance.lines,
      'imageWidth': instance.imageWidth,
      'imageHeight': instance.imageHeight,
    };

_$PageVersionImpl _$$PageVersionImplFromJson(Map<String, dynamic> json) =>
    _$PageVersionImpl(
      versionId: json['versionId'] as String,
      versionNumber: (json['versionNumber'] as num).toInt(),
      message: json['message'] as String?,
      createdAt: const HighPrecisionDateTimeConverter().fromJson(
        json['createdAt'] as String,
      ),
      ocrResult: json['ocrResult'] == null
          ? null
          : OcrResult.fromJson(json['ocrResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PageVersionImplToJson(_$PageVersionImpl instance) =>
    <String, dynamic>{
      'versionId': instance.versionId,
      'versionNumber': instance.versionNumber,
      'message': instance.message,
      'createdAt': const HighPrecisionDateTimeConverter().toJson(
        instance.createdAt,
      ),
      'ocrResult': instance.ocrResult,
    };

_$PageDetailImpl _$$PageDetailImplFromJson(Map<String, dynamic> json) =>
    _$PageDetailImpl(
      pageId: json['pageId'] as String,
      title: json['title'] as String,
      createdAt: const HighPrecisionDateTimeConverter().fromJson(
        json['createdAt'] as String,
      ),
      updatedAt: const HighPrecisionDateTimeConverter().fromJson(
        json['updatedAt'] as String,
      ),
      currentVersion: PageVersion.fromJson(
        json['currentVersion'] as Map<String, dynamic>,
      ),
      totalVersions: (json['totalVersions'] as num).toInt(),
    );

Map<String, dynamic> _$$PageDetailImplToJson(_$PageDetailImpl instance) =>
    <String, dynamic>{
      'pageId': instance.pageId,
      'title': instance.title,
      'createdAt': const HighPrecisionDateTimeConverter().toJson(
        instance.createdAt,
      ),
      'updatedAt': const HighPrecisionDateTimeConverter().toJson(
        instance.updatedAt,
      ),
      'currentVersion': instance.currentVersion,
      'totalVersions': instance.totalVersions,
    };
