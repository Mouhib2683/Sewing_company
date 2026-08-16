import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/assigned_repair_provider.dart';
import '../../providers/repair_workflow_controller.dart';
import '../../providers/technician_provider.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/read_only_field.dart';
import '../../shared/widgets/section_title.dart';

class RepairReportScreen extends ConsumerStatefulWidget {
  const RepairReportScreen({super.key});

  @override
  ConsumerState<RepairReportScreen> createState() => _RepairReportScreenState();
}

class _RepairReportScreenState extends ConsumerState<RepairReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _problemController = TextEditingController();
  final _solutionController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _problemController.dispose();
    _solutionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await ref.read(repairWorkflowControllerProvider).submitReport(
            problemDescription: _problemController.text.trim(),
            solutionApplied: _solutionController.text.trim(),
            notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          );

      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _showSuccessDialog();
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save report: $error')),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(color: AppColors.success.withOpacity(0.16), shape: BoxShape.circle),
          child: const Icon(Icons.check_rounded, color: AppColors.success, size: 30),
        ),
        title: const Text('Report submitted', textAlign: TextAlign.center),
        content: const Text(
          'The maintenance report was saved successfully. Great work!',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: 'Back to Home',
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
                context.go('/home'); // reset stack back to the shell
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repair = ref.watch(assignedRepairProvider);
    final technician = ref.watch(technicianProvider);

    if (repair == null || repair.repairStartedAt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Repair Report')),
        body: const Center(
          child: Text('No repair to report on.', style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }

    final now = DateTime.now();
    final duration = now.difference(repair.repairStartedAt!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repair Report'),
        automaticallyImplyLeading: false, // mandatory — cannot be skipped
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              const SectionTitle('Auto-filled details'),
              const SizedBox(height: 12),
              ReadOnlyField(label: 'Technician', value: technician.fullName, icon: Icons.person_outline_rounded),
              const SizedBox(height: 10),
              ReadOnlyField(label: 'Machine', value: repair.machine.displayName, icon: Icons.precision_manufacturing_outlined),
              const SizedBox(height: 10),
              ReadOnlyField(label: 'Failure type', value: repair.failureType, icon: Icons.report_problem_outlined),
              const SizedBox(height: 10),
              ReadOnlyField(
                label: 'Date',
                value: DateFormat('MMM d, yyyy').format(now),
                icon: Icons.calendar_today_outlined,
              ),
              const SizedBox(height: 10),
              ReadOnlyField(
                label: 'Repair duration',
                value: formatDurationShort(duration),
                icon: Icons.timer_outlined,
              ),

              const SizedBox(height: 28),
              const SectionTitle('Your report'),
              const SizedBox(height: 12),

              const Text('Problem Description', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _problemController,
                maxLines: 3,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(hintText: 'What was wrong with the machine?'),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'Problem description is required' : null,
              ),

              const SizedBox(height: 18),
              const Text('Repair Solution Applied', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _solutionController,
                maxLines: 3,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(hintText: 'What did you do to fix it?'),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'Repair solution is required' : null,
              ),

              const SizedBox(height: 18),
              Row(
                children: const [
                  Text('Additional Notes', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                  SizedBox(width: 6),
                  Text('(optional)', style: TextStyle(color: AppColors.textDisabled, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(hintText: 'Anything else worth mentioning?'),
              ),

              const SizedBox(height: 28),
              PrimaryButton(
                label: 'Submit Report',
                icon: Icons.send_rounded,
                isLoading: _isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
