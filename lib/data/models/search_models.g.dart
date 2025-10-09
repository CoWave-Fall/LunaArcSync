// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchResultItem _$SearchResultItemFromJson(Map<String, dynamic> json) =>
    _SearchResultItem(
      type: $enumDecode(_$SearchResultTypeEnumMap, json['type']),
      documentId: json['documentId'] as String,
      documentTitle: json['documentTitle'] as String,
      pageId: json['pageId'] as String?,
      pageTitle: json['pageTitle'] as String?,
      matchSnippet: json['matchSnippet'] as String,
    );

Map<String, dynamic> _$SearchResultItemToJson(_SearchResultItem instance) =>
    <String, dynamic>{
      'type': _$SearchResultTypeEnumMap[instance.type]!,
      'documentId': instance.documentId,
      'documentTitle': instance.documentTitle,
      'pageId': instance.pageId,
      'pageTitle': instance.pageTitle,
      'matchSnippet': instance.matchSnippet,
    };

const _$SearchResultTypeEnumMap = {
  SearchResultType.document: 'document',
  SearchResultType.page: 'page',
};
