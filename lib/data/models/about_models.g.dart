// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AboutResponse _$AboutResponseFromJson(Map<String, dynamic> json) =>
    _AboutResponse(
      appName: json['appName'] as String,
      version: json['version'] as String,
      serverName: json['serverName'] as String,
      serverIcon: json['serverIcon'] as String,
      description: json['description'] as String,
      contact: json['contact'] as String,
      serverId: json['serverId'] as String?,
    );

Map<String, dynamic> _$AboutResponseToJson(_AboutResponse instance) =>
    <String, dynamic>{
      'appName': instance.appName,
      'version': instance.version,
      'serverName': instance.serverName,
      'serverIcon': instance.serverIcon,
      'description': instance.description,
      'contact': instance.contact,
      'serverId': instance.serverId,
    };
