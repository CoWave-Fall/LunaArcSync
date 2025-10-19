import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AvatarUploadWidget extends StatefulWidget {
  final String? currentAvatarUrl;
  final Function(String filePath) onAvatarSelected;
  final VoidCallback? onAvatarDeleted;
  final double size;

  const AvatarUploadWidget({
    super.key,
    this.currentAvatarUrl,
    required this.onAvatarSelected,
    this.onAvatarDeleted,
    this.size = 100,
  });

  @override
  State<AvatarUploadWidget> createState() => _AvatarUploadWidgetState();
}

class _AvatarUploadWidgetState extends State<AvatarUploadWidget> {
  File? _selectedFile;
  bool _isHovering = false;

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        setState(() {
          _selectedFile = File(filePath);
        });
        widget.onAvatarSelected(filePath);
      }
    } catch (e) {
      debugPrint('选择图片失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('选择图片失败: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _deleteAvatar() {
    setState(() {
      _selectedFile = null;
    });
    widget.onAvatarDeleted?.call();
  }

  @override
  Widget build(BuildContext context) {
    final hasAvatar = _selectedFile != null || widget.currentAvatarUrl != null;
    
    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: Stack(
            children: [
              // 头像显示
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: _buildAvatarContent(),
                  ),
                ),
              ),
              
              // 悬停时的编辑遮罩
              if (_isHovering)
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: widget.size * 0.3,
                    ),
                  ),
                ),
              
              // 删除按钮
              if (hasAvatar && widget.onAvatarDeleted != null)
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: _deleteAvatar,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onError,
                        size: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '点击上传头像',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarContent() {
    if (_selectedFile != null) {
      return Image.file(
        _selectedFile!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar();
        },
      );
    } else if (widget.currentAvatarUrl != null && widget.currentAvatarUrl!.isNotEmpty) {
      return Image.network(
        widget.currentAvatarUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar();
        },
      );
    } else {
      return _buildDefaultAvatar();
    }
  }

  Widget _buildDefaultAvatar() {
    return Icon(
      Icons.person,
      size: widget.size * 0.5,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}

