import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../models/repair_notification.dart';
import '../../providers/notifications_provider.dart';
import '../../providers/repair_workflow_controller.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/priority_chip.dart';
import '../../shared/widgets/primary_button.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifications.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${notifications.length} waiting',
                    style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const _EmptyState()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationCard(notification: notification);
              },
            ),
    );
  }
}

class _NotificationCard extends ConsumerWidget {
  const _NotificationCard({required this.notification});
  final RepairNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(notification.machine.displayName, style: Theme.of(context).textTheme.titleLarge),
              ),
              PriorityChip(priority: notification.priority),
            ],
          ),
          const SizedBox(height: 6),
          Text(notification.failureType, style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
          const SizedBox(height: 4),
          Text(
            '${notification.machine.location} · detected ${formatTimeAgo(notification.detectedAt)}',
            style: const TextStyle(color: AppColors.textDisabled, fontSize: 12),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Accept',
            icon: Icons.check_rounded,
            backgroundColor: AppColors.success,
            foregroundColor: Colors.black,
            onPressed: () {
              ref.read(repairWorkflowControllerProvider).acceptNotification(notification.id);
              context.push('/assigned-repair');
            },
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.notifications_off_outlined, color: AppColors.textDisabled, size: 32),
            ),
            const SizedBox(height: 20),
            const Text('All clear', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text(
              'No machine failures waiting right now.\nYou\'ll be notified the moment one comes in.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
