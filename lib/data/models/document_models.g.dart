// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DocumentImpl _$$DocumentImplFromJson(Map<String, dynamic> json) =>
    _$DocumentImpl(
      documentId: json['documentId'] as String,
      title: json['title'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      createdAt: const HighPrecisionDateTimeConverter().fromJson(
        json['createdAt'] as String,
      ),
      updatedAt: const HighPrecisionDateTimeConverter().fromJson(
        json['updatedAt'] as String,
      ),
      pageCount: (json['pageCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DocumentImplToJson(_$DocumentImpl instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'title': instance.title,
      'tags': instance.tags,
      'createdAt': const HighPrecisionDateTimeConverter().toJson(
        instance.createdAt,
      ),
      'updatedAt': const HighPrecisionDateTimeConverter().toJson(
        instance.updatedAt,
      ),
      'pageCount': instance.pageCount,
    };

_$DocumentDetailImpl _$$DocumentDetailImplFromJson(Map<String, dynamic> json) =>
    _$DocumentDetailImpl(
      documentId: json['documentId'] as String,
      title: json['title'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      createdAt: const HighPrecisionDateTimeConverter().fromJson(
        json['createdAt'] as String,
      ),
      updatedAt: const HighPrecisionDateTimeConverter().fromJson(
        json['updatedAt'] as String,
      ),
      pages:
          (json['pages'] as List<dynamic>?)
              ?.map((e) => Page.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DocumentDetailImplToJson(
  _$DocumentDetailImpl instance,
) => <String, dynamic>{
  'documentId': instance.documentId,
  'title': instance.title,
  'tags': instance.tags,
  'createdAt': const HighPrecisionDateTimeConverter().toJson(
    instance.createdAt,
  ),
  'updatedAt': const HighPrecisionDateTimeConverter().toJson(
    instance.updatedAt,
  ),
  'pages': instance.pages,
};

_$DocumentStatsImpl _$$DocumentStatsImplFromJson(Map<String, dynamic> json) =>
    _$DocumentStatsImpl(
      totalDocuments: (json['totalDocuments'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$$DocumentStatsImplToJson(_$DocumentStatsImpl instance) =>
    <String, dynamic>{
      'totalDocuments': instance.totalDocuments,
      'totalPages': instance.totalPages,
    };
