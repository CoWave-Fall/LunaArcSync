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

_Page _$PageFromJson(Map<String, dynamic> json) => _Page(
  pageId: json['pageId'] as String,
  title: json['title'] as String,
  createdAt: const HighPrecisionDateTimeConverter().fromJson(
    json['createdAt'] as String,
  ),
  updatedAt: const HighPrecisionDateTimeConverter().fromJson(
    json['updatedAt'] as String,
  ),
  order: (json['order'] as num?)?.toInt() ?? 0,
  thumbnailUrl: json['thumbnailUrl'] as String?,
);

Map<String, dynamic> _$PageToJson(_Page instance) => <String, dynamic>{
  'pageId': instance.pageId,
  'title': instance.title,
  'createdAt': const HighPrecisionDateTimeConverter().toJson(
    instance.createdAt,
  ),
  'updatedAt': const HighPrecisionDateTimeConverter().toJson(
    instance.updatedAt,
  ),
  'order': instance.order,
  'thumbnailUrl': instance.thumbnailUrl,
};

_Bbox _$BboxFromJson(Map<String, dynamic> json) => _Bbox(
  x1: (json['x1'] as num).toInt(),
  y1: (json['y1'] as num).toInt(),
  x2: (json['x2'] as num).toInt(),
  y2: (json['y2'] as num).toInt(),
  normalizedX1: (json['normalizedX1'] as num?)?.toDouble(),
  normalizedY1: (json['normalizedY1'] as num?)?.toDouble(),
  normalizedX2: (json['normalizedX2'] as num?)?.toDouble(),
  normalizedY2: (json['normalizedY2'] as num?)?.toDouble(),
);

Map<String, dynamic> _$BboxToJson(_Bbox instance) => <String, dynamic>{
  'x1': instance.x1,
  'y1': instance.y1,
  'x2': instance.x2,
  'y2': instance.y2,
  'normalizedX1': instance.normalizedX1,
  'normalizedY1': instance.normalizedY1,
  'normalizedX2': instance.normalizedX2,
  'normalizedY2': instance.normalizedY2,
};

_OcrWord _$OcrWordFromJson(Map<String, dynamic> json) => _OcrWord(
  text: json['text'] as String,
  bbox: Bbox.fromJson(json['bbox'] as Map<String, dynamic>),
  confidence: (json['confidence'] as num).toDouble(),
);

Map<String, dynamic> _$OcrWordToJson(_OcrWord instance) => <String, dynamic>{
  'text': instance.text,
  'bbox': instance.bbox,
  'confidence': instance.confidence,
};

_OcrLine _$OcrLineFromJson(Map<String, dynamic> json) => _OcrLine(
  words: (json['words'] as List<dynamic>)
      .map((e) => OcrWord.fromJson(e as Map<String, dynamic>))
      .toList(),
  text: json['text'] as String,
  bbox: Bbox.fromJson(json['bbox'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OcrLineToJson(_OcrLine instance) => <String, dynamic>{
  'words': instance.words,
  'text': instance.text,
  'bbox': instance.bbox,
};

_OcrResult _$OcrResultFromJson(Map<String, dynamic> json) => _OcrResult(
  lines: (json['lines'] as List<dynamic>)
      .map((e) => OcrLine.fromJson(e as Map<String, dynamic>))
      .toList(),
  imageWidth: (json['imageWidth'] as num).toInt(),
  imageHeight: (json['imageHeight'] as num).toInt(),
);

Map<String, dynamic> _$OcrResultToJson(_OcrResult instance) =>
    <String, dynamic>{
      'lines': instance.lines,
      'imageWidth': instance.imageWidth,
      'imageHeight': instance.imageHeight,
    };

_PageVersion _$PageVersionFromJson(Map<String, dynamic> json) => _PageVersion(
  versionId: json['versionId'] as String,
  versionNumber: (json['versionNumber'] as num).toInt(),
  message: json['message'] as String?,
  createdAt: const HighPrecisionDateTimeConverter().fromJson(
    json['createdAt'] as String,
  ),
  ocrResult: json['ocrResult'] == null
      ? null
      : OcrResult.fromJson(json['ocrResult'] as Map<String, dynamic>),
  fileUrl: json['fileUrl'] as String?,
  mimeType: json['mimeType'] as String?,
);

Map<String, dynamic> _$PageVersionToJson(_PageVersion instance) =>
    <String, dynamic>{
      'versionId': instance.versionId,
      'versionNumber': instance.versionNumber,
      'message': instance.message,
      'createdAt': const HighPrecisionDateTimeConverter().toJson(
        instance.createdAt,
      ),
      'ocrResult': instance.ocrResult,
      'fileUrl': instance.fileUrl,
      'mimeType': instance.mimeType,
    };

_PageDetail _$PageDetailFromJson(Map<String, dynamic> json) => _PageDetail(
  pageId: json['pageId'] as String,
  title: json['title'] as String,
  createdAt: const HighPrecisionDateTimeConverter().fromJson(
    json['createdAt'] as String,
  ),
  updatedAt: const HighPrecisionDateTimeConverter().fromJson(
    json['updatedAt'] as String,
  ),
  currentVersion: json['currentVersion'] == null
      ? null
      : PageVersion.fromJson(json['currentVersion'] as Map<String, dynamic>),
  totalVersions: (json['totalVersions'] as num).toInt(),
  thumbnailUrl: json['thumbnailUrl'] as String?,
);

Map<String, dynamic> _$PageDetailToJson(_PageDetail instance) =>
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
      'thumbnailUrl': instance.thumbnailUrl,
    };
