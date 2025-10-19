import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luna_arc_sync/core/api/json_converters.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

// Model for the login request body
@freezed
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

// Model for the successful login response body
@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String token,
    @UnixTimestampConverter()
    required DateTime expiration,
    required String userId,
    required String username,
    required String nickname,
    required String email,
    String? avatar,
    String? bio,
    required bool isAdmin,
    required String role,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

// Model for the register request body
@freezed
abstract class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String email,
    required String password,
    required String confirmPassword,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}