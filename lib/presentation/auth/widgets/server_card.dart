import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna_arc_sync/core/storage/server_cache_service.dart';
import 'package:luna_arc_sync/core/storage/image_cache_service.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'dart:io';

class ServerCard extends StatefulWidget {
  final CachedServerInfo serverInfo;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const ServerCard({
    super.key,
    required this.serverInfo,
    required this.onTap,
    this.onLongPress,
  });

  @override
  State<ServerCard> createState() => _ServerCardState();
}

class _ServerCardState extends State<ServerCard> {
  final _imageCacheService = getIt<ImageCacheService>();
  File? _cachedImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServerIcon();
  }

  Future<void> _loadServerIcon() async {
    if (widget.serverInfo.serverUrl == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // 构建完整的图标URL
      final baseUrl = widget.serverInfo.serverUrl!;
      final iconPath = widget.serverInfo.about.serverIcon;
      final iconUrl = iconPath.startsWith('http') 
          ? iconPath 
          : '$baseUrl$iconPath';

      // 尝试获取缓存的图片
      final cachedFile = await _imageCacheService.getCachedImage(iconUrl);
      if (cachedFile != null && await cachedFile.exists()) {
        setState(() {
          _cachedImage = cachedFile;
          _isLoading = false;
        });
        return;
      }

      // 如果没有缓存，尝试下载并缓存
      final downloadedFile = await _imageCacheService.cacheImage(iconUrl);
      if (downloadedFile != null && mounted) {
        setState(() {
          _cachedImage = downloadedFile;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('🔍 加载服务器图标失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 服务器图标
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: _buildServerIcon(),
              ),
              const SizedBox(width: 16),
              
              // 服务器信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.serverInfo.about.serverName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.serverInfo.about.appName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.serverInfo.serverUrl != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _extractHostFromUrl(widget.serverInfo.serverUrl!),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              
              // 箭头图标
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServerIcon() {
    if (_isLoading) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_cachedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          _cachedImage!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultIcon();
          },
        ),
      );
    }

    return _buildDefaultIcon();
  }

  Widget _buildDefaultIcon() {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          'assets/images/logo.svg',
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.primary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  String _extractHostFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return '${uri.host}:${uri.port}';
    } catch (e) {
      return url;
    }
  }
}
