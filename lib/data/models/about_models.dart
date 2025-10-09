import 'package:freezed_annotation/freezed_annotation.dart';

part 'about_models.freezed.dart';
part 'about_models.g.dart';

@freezed
abstract class AboutResponse with _$AboutResponse {
  const factory AboutResponse({
    required String appName,
    required String version,
    required String serverName,
    required String serverIcon,
    required String description,
    required String contact,
    String? serverId,
  }) = _AboutResponse;

  factory AboutResponse.fromJson(Map<String, dynamic> json) =>
      _$AboutResponseFromJson(json);
}
