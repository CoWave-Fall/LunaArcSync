import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/models/about_models.dart';
import 'package:luna_arc_sync/data/repositories/about_repository.dart';

part 'about_cubit.freezed.dart';

@freezed
sealed class AboutState with _$AboutState {
  const factory AboutState.initial() = _Initial;
  const factory AboutState.loading() = _Loading;
  const factory AboutState.loaded(AboutResponse about) = _Loaded;
  const factory AboutState.error({
    required String message,
    @Default(false) bool isConnectionError,
    @Default(false) bool isAuthError,
  }) = _Error;
}

@injectable
class AboutCubit extends Cubit<AboutState> {
  final IAboutRepository _aboutRepository;

  AboutCubit(this._aboutRepository) : super(const AboutState.initial());

  Future<void> loadAbout() async {
    emit(const AboutState.loading());
    try {
      final about = await _aboutRepository.getAbout();
      emit(AboutState.loaded(about));
    } catch (e) {
      debugPrint('🔍 AboutCubit: Error loading about - $e');
      
      // 区分不同类型的错误
      bool isConnectionError = false;
      bool isAuthError = false;
      String errorMessage = e.toString();
      
      if (e is DioException) {
        // 认证错误
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          isAuthError = true;
          errorMessage = 'Authentication failed. Please login again.';
        }
        // 连接错误
        else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.unknown) {
          isConnectionError = true;
          errorMessage = 'Unable to connect to server. Please check your connection or try a different server.';
        }
      }
      
      emit(AboutState.error(
        message: errorMessage,
        isConnectionError: isConnectionError,
        isAuthError: isAuthError,
      ));
    }
  }
}
