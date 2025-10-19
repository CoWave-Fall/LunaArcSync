import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:luna_arc_sync/data/models/user_models.dart';

part 'user_state.freezed.dart';

@freezed
abstract class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.currentUserLoaded(UserDto user) = _CurrentUserLoaded;
  const factory UserState.allUsersLoaded(List<AdminUserListDto> users) = _AllUsersLoaded;
  const factory UserState.userDetailsLoaded(UserDto user) = _UserDetailsLoaded;
  const factory UserState.adminStatsLoaded(AdminStatsDto stats) = _AdminStatsLoaded;
  const factory UserState.error(String message) = _Error;
  // 新增：包含所有数据的完整状态
  const factory UserState.dataLoaded({
    required UserDto currentUser,
    List<AdminUserListDto>? allUsers,
    AdminStatsDto? adminStats,
  }) = _DataLoaded;
}
