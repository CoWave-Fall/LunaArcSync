import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  // 初始状态
  const factory AuthState.initial() = _Initial;

  // 已认证状态
  const factory AuthState.authenticated({
    required String userId,
    required bool isAdmin,
    required String role,
  }) = _Authenticated;

  // 未认证状态，但内部可以包含更丰富的信息
  const factory AuthState.unauthenticated({
    @Default(false) bool isLoading, // 是否正在加载 (例如，点击登录后)
    String? error,                 // 错误信息
  }) = _Unauthenticated;
}