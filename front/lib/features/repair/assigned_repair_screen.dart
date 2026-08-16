import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../models/assigned_repair.dart';
import '../../providers/assigned_repair_provider.dart';
import '../../providers/repair_workflow_controller.dart';
import '../../providers/ticker_provider.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/priority_chip.dart';
import '../../shared/widgets/primary_button.dart';

class AssignedRepairScreen extends ConsumerWidget {
  const AssignedRepairScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repair = ref.watch(assignedRepairProvider);
    ref.watch(tickerProvider); // drives the countdown rebuild every second

    if (repair == null) {
      // Defensive fallback — shouldn't normally be reachable via the UI flow.
      return Scaffold(
        appBar: AppBar(title: const Text('Assignment')),
        body: const Center(
          child: Text('No active assignment.', style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }

    final remaining = repair.prepDeadline.difference(DateTime.now());
    final isOverdue = remaining.isNegative;
    final displayRemaining = isOverdue ? Duration.zero : remaining;
    final progress = 1 - (displayRemaining.inSeconds / AssignedRepair.prepWindow.inSeconds);

    return Scaffold(
      appBar: AppBar(title: const Text('Assignment')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(repair.machine.displayName, style: Theme.of(context).textTheme.titleLarge),
                        ),
                        PriorityChip(priority: repair.priority),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(repair.failureType, style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(repair.machine.location, style: const TextStyle(color: AppColors.textDisabled, fontSize: 13)),
                    const Divider(height: 28),
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, size: 18, color: AppColors.success),
                        const SizedBox(width: 8),
                        Text(
                          'Accepted at ${formatClock(repair.acceptedAt)}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Text(
                isOverdue ? 'Prep window elapsed' : 'Time to reach the machine',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 16),

              Center(
                child: SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 220,
                        height: 220,
                        child: CircularProgressIndicator(
                          value: progress.clamp(0, 1),
                          strokeWidth: 10,
                          backgroundColor: AppColors.border,
                          valueColor: AlwaysStoppedAnimation(isOverdue ? AppColors.error : AppColors.accent),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formatStopwatch(displayRemaining),
                            style: TextStyle(
                              color: isOverdue ? AppColors.error : AppColors.textPrimary,
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isOverdue ? 'Get there now' : 'minutes remaining',
                            style: const TextStyle(color: AppColors.textDisabled, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              PrimaryButton(
                label: "I'm at the Machine — Start Repair",
                icon: Icons.play_arrow_rounded,
                onPressed: () {
                  ref.read(repairWorkflowControllerProvider).startRepair();
                  context.pushReplacement('/repair');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
