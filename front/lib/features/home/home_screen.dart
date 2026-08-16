import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../models/assigned_repair.dart';
import '../../models/technician.dart';
import '../../providers/assigned_repair_provider.dart';
import '../../providers/notifications_provider.dart';
import '../../providers/repair_history_provider.dart';
import '../../providers/technician_provider.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/priority_chip.dart';
import '../../shared/widgets/section_title.dart';
import '../../shared/widgets/status_badge.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final technician = ref.watch(technicianProvider);
    final assigned = ref.watch(assignedRepairProvider);
    final history = ref.watch(repairHistoryProvider);
    final waitingCount = ref.watch(notificationsProvider).length;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _Header(technician: technician),
                  const SizedBox(height: 20),

                  if (assigned != null) ...[
                    _CurrentAssignmentCard(repair: assigned),
                    const SizedBox(height: 20),
                  ],

                  SectionTitle(
                    'Today',
                    trailing: Text(
                      '${history.length} completed',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.check_circle_outline_rounded,
                          iconColor: AppColors.success,
                          label: 'Completed',
                          value: '${history.length}',
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.notifications_active_outlined,
                          iconColor: AppColors.accent,
                          label: 'Waiting',
                          value: '$waitingCount',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const SectionTitle('Quick actions'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickAction(
                          icon: Icons.notifications_outlined,
                          label: 'Notifications',
                          onTap: () => context.go('/notifications'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _QuickAction(
                          icon: Icons.support_agent_rounded,
                          label: 'Call Supervisor',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('This is a UI-only prototype action.')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  if (history.isNotEmpty) ...[
                    const SectionTitle('Recent repairs'),
                    const SizedBox(height: 12),
                    ...history.take(3).map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AppCard(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withOpacity(0.14),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.check_rounded, color: AppColors.success, size: 20),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Machine #${entry.machineCode} · ${entry.failureType}',
                                            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${formatTimeAgo(entry.completedAt)} · ${formatDurationShort(entry.duration)}',
                                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.technician});
  final Technician technician;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome,', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 2),
              Text(technician.fullName, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              StatusBadge(status: technician.status),
            ],
          ),
        ),
        CircleAvatar(
          radius: 26,
          backgroundColor: AppColors.surfaceElevated,
          child: Text(
            technician.fullName.trim().isNotEmpty ? technician.fullName.trim()[0] : '?',
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ),
      ],
    );
  }
}

class _CurrentAssignmentCard extends ConsumerWidget {
  const _CurrentAssignmentCard({required this.repair});
  final AssignedRepair repair;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRepairing = repair.workflowStatus == RepairWorkflowStatus.repairing;
    final route = isRepairing ? '/repair' : '/assigned-repair';

    return AppCard(
      onTap: () => context.push(route),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isRepairing ? 'IN PROGRESS' : 'PREPARING',
                  style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w800),
                ),
              ),
              const Spacer(),
              PriorityChip(priority: repair.priority),
            ],
          ),
          const SizedBox(height: 14),
          Text(repair.machine.displayName, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(repair.failureType, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                isRepairing ? 'Continue repair' : 'Go to assignment',
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.iconColor, required this.label, required this.value});

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Column(
        children: [
          Icon(icon, color: AppColors.textPrimary, size: 24),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
