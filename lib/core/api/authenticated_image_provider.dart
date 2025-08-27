import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:luna_arc_sync/core/api/api_client.dart';

@immutable
class AuthenticatedImageProvider extends ImageProvider<AuthenticatedImageProvider> {
  final String url;
  final ApiClient apiClient;

  const AuthenticatedImageProvider(this.url, this.apiClient);

  @override
  Future<AuthenticatedImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AuthenticatedImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadBuffer(
    AuthenticatedImageProvider key, 
    DecoderBufferCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0, // Adjust scale if necessary
      informationCollector: () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image provider', this),
          DiagnosticsProperty<AuthenticatedImageProvider>('Image key', key),
        ];
      },
    );
  }

  Future<ui.Codec> _loadAsync(
    AuthenticatedImageProvider key, 
    DecoderBufferCallback decode,
  ) async {
    assert(key == this);

    try {
      final response = await apiClient.dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode != 200) {
        throw NetworkImageLoadException(
          statusCode: response.statusCode ?? 0,
          uri: Uri.parse(url),
        );
      }

      final bytes = response.data as Uint8List;
      if (bytes.isEmpty) {
        throw Exception('AuthenticatedImageProvider: Empty response for $url');
      }

      return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
    } catch (e) {
      // Depending on your error handling strategy, you might want to rethrow
      // the error, or handle it gracefully by loading a placeholder image.
      PaintingBinding.instance.imageCache.evict(key);
      rethrow;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is AuthenticatedImageProvider && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() => '$runtimeType("$url")';
}
