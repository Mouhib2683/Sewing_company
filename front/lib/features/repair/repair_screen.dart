import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/assigned_repair_provider.dart';
import '../../providers/ticker_provider.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/priority_chip.dart';
import '../../shared/widgets/primary_button.dart';

class RepairScreen extends ConsumerWidget {
  const RepairScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repair = ref.watch(assignedRepairProvider);
    ref.watch(tickerProvider); // drives the timer rebuild every second

    if (repair == null || repair.repairStartedAt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Repair in progress')),
        body: const Center(
          child: Text('No repair in progress.', style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }

    final elapsed = DateTime.now().difference(repair.repairStartedAt!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repair in progress'),
        automaticallyImplyLeading: false, // technician shouldn't navigate back mid-repair
      ),
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
                  ],
                ),
              ),

              const Spacer(),

              const Text(
                'Repair time',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 16),

              Center(
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceElevated,
                    border: Border.all(color: AppColors.accent.withOpacity(0.5), width: 3),
                  ),
                  child: Center(
                    child: Text(
                      formatStopwatch(elapsed),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              PrimaryButton(
                label: 'Finish Repair',
                icon: Icons.flag_rounded,
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
                onPressed: () => context.push('/repair-report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
