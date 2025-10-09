import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';

abstract class IDataTransferRepository {
  Future<Uint8List> exportMyData();
  Future<void> importMyData(PlatformFile file);
}

@LazySingleton(as: IDataTransferRepository)
class DataTransferRepository implements IDataTransferRepository {
  final ApiClient _apiClient;

  DataTransferRepository(this._apiClient);

  @override
  Future<Uint8List> exportMyData() async {
    try {
      final response = await _apiClient.dio.get(
        '/api/data/export/my',
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data as Uint8List;
    } on DioException catch (e) {
      // Provide more specific error messages if possible
      throw Exception('Failed to export data: ${e.message}');
    }
  }

  @override
  Future<void> importMyData(PlatformFile file) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          file.bytes!,
          filename: file.name,
        ),
      });
      await _apiClient.dio.post('/api/data/import/my', data: formData);
    } on DioException catch (e) {
      // Provide more specific error messages based on status code or response body
      throw Exception('Failed to import data: ${e.response?.data?['message'] ?? e.message}');
    }
  }
}
