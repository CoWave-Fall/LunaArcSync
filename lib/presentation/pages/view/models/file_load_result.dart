import 'dart:typed_data';

/// 文件加载结果数据模型
/// 用于封装从网络或缓存加载的文件数据
class FileLoadResult {
  /// 文件字节数据
  final Uint8List bytes;

  /// 文件内容类型
  final String contentType;

  /// 是否来自缓存
  final bool fromCache;

  const FileLoadResult({
    required this.bytes,
    required this.contentType,
    required this.fromCache,
  });

  @override
  String toString() {
    return 'FileLoadResult(contentType: $contentType, fromCache: $fromCache, bytes: ${bytes.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FileLoadResult &&
        other.contentType == contentType &&
        other.fromCache == fromCache &&
        other.bytes.length == bytes.length;
  }

  @override
  int get hashCode {
    return contentType.hashCode ^ fromCache.hashCode ^ bytes.length.hashCode;
  }
}
