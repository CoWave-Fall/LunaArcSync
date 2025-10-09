import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/data/repositories/data_transfer_repository.dart';
import 'data_transfer_state.dart';

@injectable
class DataTransferCubit extends Cubit<DataTransferState> {
  final IDataTransferRepository _repository;

  DataTransferCubit(this._repository) : super(const DataTransferState.initial());

  Future<void> exportData() async {
    emit(const DataTransferState.loading('Exporting your data...'));
    try {
      final data = await _repository.exportMyData();
      emit(DataTransferState.exportSuccess(data));
    } catch (e) {
      emit(DataTransferState.failure(e.toString()));
    }
  }

  Future<void> importData(PlatformFile file) async {
    emit(const DataTransferState.loading('Importing your data...'));
    try {
      await _repository.importMyData(file);
      emit(const DataTransferState.importSuccess());
    } catch (e) {
      emit(DataTransferState.failure(e.toString()));
    }
  }

  void reset() {
    emit(const DataTransferState.initial());
  }
}
