
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/data/models/user_models.dart';
import 'package:luna_arc_sync/presentation/user/cubit/user_cubit.dart';
import 'package:luna_arc_sync/presentation/user/widgets/avatar_upload_widget.dart';

class UserProfileForm extends StatefulWidget {
  final UserDto user;
  final Function(UpdateUserProfileDto) onSave;
  final VoidCallback onCancel;

  const UserProfileForm({
    super.key,
    required this.user,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<UserProfileForm> createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  
  bool _isUploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
    _nicknameController.text = widget.user.nickname;
    _emailController.text = widget.user.email;
    _bioController.text = widget.user.bio ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }
  
  Future<void> _handleAvatarUpload(String filePath) async {
    setState(() {
      _isUploadingAvatar = true;
    });
    
    try {
      await context.read<UserCubit>().uploadAvatar(filePath);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('头像上传成功'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('头像上传失败: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingAvatar = false;
        });
      }
    }
  }
  
  Future<void> _handleAvatarDelete() async {
    setState(() {
      _isUploadingAvatar = true;
    });
    
    try {
      await context.read<UserCubit>().deleteAvatar();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('头像删除成功'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('头像删除失败: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingAvatar = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '编辑用户信息',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // 头像上传
            Center(
              child: _isUploadingAvatar
                  ? const CircularProgressIndicator()
                  : AvatarUploadWidget(
                      currentAvatarUrl: widget.user.avatar,
                      onAvatarSelected: _handleAvatarUpload,
                      onAvatarDeleted: _handleAvatarDelete,
                      size: 120,
                    ),
            ),
            const SizedBox(height: 24),
            
            // 用户名
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: '用户名',
                hintText: '请输入用户名',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '用户名不能为空';
                }
                if (value.length > 50) {
                  return '用户名长度不能超过50个字符';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // 昵称
            TextFormField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: '昵称',
                hintText: '请输入昵称',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '昵称不能为空';
                }
                if (value.length > 50) {
                  return '昵称长度不能超过50个字符';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // 邮箱
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: '邮箱',
                hintText: '请输入邮箱地址',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '邮箱不能为空';
                }
                if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
                  return '邮箱格式不正确';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // 个人简介
            TextFormField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: '个人简介',
                hintText: '请输入个人简介',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value != null && value.length > 200) {
                  return '个人简介长度不能超过200个字符';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            
            // 操作按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('取消'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _handleSave,
                  child: const Text('保存'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final profile = UpdateUserProfileDto(
        username: _usernameController.text.trim(),
        nickname: _nicknameController.text.trim(),
        email: _emailController.text.trim(),
        bio: _bioController.text.trim().isEmpty 
            ? null 
            : _bioController.text.trim(),
      );
      
      widget.onSave(profile);
    }
  }
}
