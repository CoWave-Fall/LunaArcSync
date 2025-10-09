import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/models/about_models.dart';
import 'package:luna_arc_sync/data/repositories/about_repository.dart';

part 'about_cubit.freezed.dart';

@freezed
class AboutState with _$AboutState {
  const factory AboutState.initial() = _Initial;
  const factory AboutState.loading() = _Loading;
  const factory AboutState.loaded(AboutResponse about) = _Loaded;
  const factory AboutState.error(String message) = _Error;
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
      emit(AboutState.error(e.toString()));
    }
  }
}
