// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:luna_arc_sync/core/di/injection.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/version_history_cubit.dart';
import 'package:luna_arc_sync/presentation/pages/cubit/version_history_state.dart';

class VersionHistoryPage extends StatefulWidget {
  final String pageId;
  // 虽然我们现在根据列表顺序判断当前版本，但保留此参数以备将来使用或调试
  final String? currentVersionId;

  const VersionHistoryPage({
    super.key,
    required this.pageId,
    this.currentVersionId,
  });

  @override
  State<VersionHistoryPage> createState() => _VersionHistoryPageState();
}

class _VersionHistoryPageState extends State<VersionHistoryPage> {
  // 显示回滚确认对话框的私有方法
  Future<void> _showRevertConfirmationDialog(BuildContext context, String targetVersionId) async {
    // 从有效的上下文中预先读取 Cubit
    final cubit = context.read<VersionHistoryCubit>();
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // 防止在加载时意外关闭
      builder: (dialogContext) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Confirm Revert'),
              content: const Text('Are you sure you want to revert to this version? This will create a new version based on the selected one.'),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() { isLoading = true; });
                          try {
                            // 使用预先读取的 Cubit 实例
                            await cubit.revertToVersion(targetVersionId);
                           if (mounted) {
                              // ignore: use_build_context_synchronously
                              Navigator.of(dialogContext).pop(false);
                            }
                          } catch (e) {
                            if (mounted) Navigator.of(dialogContext).pop(false);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                              );
                            }
                          }
                        },
                  child: isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );

    // 根据对话框的返回结果，显示成功提示
    if (confirmed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully reverted version.'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<VersionHistoryCubit>()..fetchHistory(widget.pageId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.versionHistory ?? 'Version History'),
        ),
        body: BlocConsumer<VersionHistoryCubit, VersionHistoryState>(
          // listener 可以在这里全局监听状态变化，但我们已在对话框中处理了提示
          listener: (context, state) {},
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              failure: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.read<VersionHistoryCubit>().fetchHistory(widget.pageId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              success: (versions, docId, currentVersionId) {
                if (versions.isEmpty) {
                  return Center(child: Text(AppLocalizations.of(context)?.noVersionHistoryFound ?? 'No version history found.'));
                }
                return RefreshIndicator(
                  onRefresh: () => context.read<VersionHistoryCubit>().fetchHistory(widget.pageId),
                  child: ListView.builder(
                    itemCount: versions.length,
                    itemBuilder: (context, index) {
                      final version = versions[index];
                      // **修正**: 使用来自状态的 currentVersionId 来判断当前版本
                      final isCurrentVersion = version.versionId == currentVersionId;
                      final formattedDate = DateFormat.yMMMd().add_jms().format(version.createdAt.toLocal());

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        elevation: isCurrentVersion ? 4 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: isCurrentVersion
                              ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
                              : BorderSide.none,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isCurrentVersion ? Theme.of(context).primaryColor : Colors.grey,
                            foregroundColor: Colors.white,
                            child: Text('${version.versionNumber}'),
                          ),
                          title: Text(version.message ?? 'Version ${version.versionNumber}'),
                          subtitle: Text('Created at: $formattedDate'),
                          trailing: isCurrentVersion
                              ? const Chip(
                                  label: Text('Current'),
                                  backgroundColor: Colors.green,
                                  labelStyle: TextStyle(color: Colors.white),
                                )
                              : ElevatedButton(
                                  onPressed: () => _showRevertConfirmationDialog(context, version.versionId),
                                  child: const Text('Revert'),
                                ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}