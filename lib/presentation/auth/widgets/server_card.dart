import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luna_arc_sync/core/storage/server_cache_service.dart';
import 'package:luna_arc_sync/core/storage/image_cache_service.dart';
import 'package:luna_arc_sync/core/services/server_status_service.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/core/animations/animated_page_content.dart';
import 'dart:io';

class ServerCard extends StatefulWidget {
  final CachedServerInfo serverInfo;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final ServerStatus? status; // 服务器状态

  const ServerCard({
    super.key,
    required this.serverInfo,
    required this.onTap,
    this.onLongPress,
    this.status,
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
    final isOffline = widget.status == ServerStatus.offline;
    final isChecking = widget.status == ServerStatus.checking;
    
    return AnimatedInteractiveCard(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      hoverScale: 1.01,
      pressScale: 0.98,
      child: Card(
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
              // 服务器图标（离线时变灰）
              Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    ),
                    child: _buildServerIcon(),
                  ),
                  // 离线时的灰色遮罩
                  if (isOffline)
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.withValues(alpha: 0.6),
                      ),
                    ),
                ],
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
                        color: isOffline 
                            ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // 显示用户昵称或用户名
                    if (widget.serverInfo.nickname != null || widget.serverInfo.username != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 12,
                            color: Theme.of(context).colorScheme.primary.withValues(
                              alpha: isOffline ? 0.5 : 1.0,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.serverInfo.nickname?.isNotEmpty == true 
                                  ? widget.serverInfo.nickname! 
                                  : widget.serverInfo.username ?? '',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary.withValues(
                                  alpha: isOffline ? 0.5 : 1.0,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      widget.serverInfo.about.appName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(
                          alpha: isOffline ? 0.5 : 1.0,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.serverInfo.serverUrl != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _extractHostFromUrl(widget.serverInfo.serverUrl!),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(
                            alpha: isOffline ? 0.5 : 1.0,
                          ),
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              
              // 状态指示器（离线/检查中）
              if (isChecking)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else if (isOffline)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    '离线',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ),
              
              // 箭头图标
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(
                  alpha: isOffline ? 0.5 : 1.0,
                ),
              ),
              ],
            ),
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
