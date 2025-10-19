import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/repositories/document_repository.dart';
import 'package:luna_arc_sync/data/repositories/user_repository.dart';
import 'overview_state.dart';

@injectable
class OverviewCubit extends Cubit<OverviewState> {
  final IUserRepository _userRepository;
  final IDocumentRepository _documentRepository;

  OverviewCubit(
    this._userRepository,
    this._documentRepository,
  ) : super(const OverviewState.initial());

  Future<void> fetchOverviewData() async {
    emit(const OverviewState.loading());
    try {
      final adminStats = await _userRepository.getAdminStats();
      final userCount = adminStats.totalUsers;
      final documentStats = await _documentRepository.getStats();

      emit(OverviewState.success(
        userCount: userCount,
        pageCount: documentStats.totalPages,
        documentCount: documentStats.totalDocuments,
      ));
    } catch (e) {
      emit(OverviewState.failure(message: e.toString()));
    }
  }
}
