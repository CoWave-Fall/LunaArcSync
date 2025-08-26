import 'package:flutter/material.dart';
import 'package:luna_arc_sync/l10n/app_localizations.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(l10n.overviewAppBarTitle),
          ),
          _buildWelcomeHeader(context),
          _buildStatsGrid(context),
          _buildSectionHeader(context, l10n.overviewRecentActivity),
          _buildRecentActivityList(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back!', // This could be localized as well
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Here is a summary of your activities.', // And this
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    // Placeholder data for stats
    final stats = [
      {'icon': Icons.document_scanner, 'label': 'Documents', 'count': '1,234'},
      {'icon': Icons.sync, 'label': 'Synced', 'count': '987'},
      {'icon': Icons.pending_actions, 'label': 'Pending', 'count': '56'},
      {'icon': Icons.error_outline, 'label': 'Errors', 'count': '2'},
    ];

    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final stat = stats[index];
            return _StatCard(
              icon: stat['icon'] as IconData,
              label: stat['label'] as String,
              count: stat['count'] as String,
            );
          },
          childCount: stats.length,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  Widget _buildRecentActivityList(BuildContext context) {
    // Placeholder data for recent activities
    final recentActivities = [
      {'title': 'Scanned "Invoice #5021"', 'subtitle': 'Today, 10:45 AM'},
      {'title': 'Synced "Meeting Notes"', 'subtitle': 'Today, 9:12 AM'},
      {'title': 'Error on "Photo_003.jpg"', 'subtitle': 'Yesterday, 3:30 PM'},
      {'title': 'Scanned "Receipt_Grocery"', 'subtitle': 'Yesterday, 1:05 PM'},
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final activity = recentActivities[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: ListTile(
              leading: const Icon(Icons.history),
              title: Text(activity['title']!),
              subtitle: Text(activity['subtitle']!),
              onTap: () {
                // Handle tap
              },
            ),
          );
        },
        childCount: recentActivities.length,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.count,
  });

  final IconData icon;
  final String label;
  final String count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 32, color: colorScheme.primary),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
