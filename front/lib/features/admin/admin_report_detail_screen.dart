import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../models/admin_report.dart';
import '../../shared/utils/formatters.dart';
import '../../shared/widgets/read_only_field.dart';
import '../../shared/widgets/section_title.dart';

class AdminReportDetailScreen extends StatelessWidget {
  const AdminReportDetailScreen({super.key, required this.report});

  final AdminReport report;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Detail')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            const SectionTitle('Details'),
            const SizedBox(height: 12),
            ReadOnlyField(label: 'Technician', value: report.technicianName, icon: Icons.person_outline_rounded),
            const SizedBox(height: 10),
            ReadOnlyField(
              label: 'Machine',
              value: 'Machine #${report.machineCode}',
              icon: Icons.precision_manufacturing_outlined,
            ),
            const SizedBox(height: 10),
            ReadOnlyField(label: 'Failure type', value: report.failureType, icon: Icons.report_problem_outlined),
            const SizedBox(height: 10),
            ReadOnlyField(
              label: 'Submitted',
              value: DateFormat('MMM d, yyyy • HH:mm').format(report.createdAt),
              icon: Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 10),
            ReadOnlyField(
              label: 'Repair duration',
              value: formatDurationShort(report.duration),
              icon: Icons.timer_outlined,
            ),
            const SizedBox(height: 28),
            const SectionTitle('Report'),
            const SizedBox(height: 12),
            const Text(
              'Problem Description',
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _ReadOnlyParagraph(text: report.problemDescription),
            const SizedBox(height: 18),
            const Text(
              'Repair Solution Applied',
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _ReadOnlyParagraph(text: report.solutionApplied),
            if (report.notes != null && report.notes!.isNotEmpty) ...[
              const SizedBox(height: 18),
              const Text(
                'Additional Notes',
                style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              _ReadOnlyParagraph(text: report.notes!),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyParagraph extends StatelessWidget {
  const _ReadOnlyParagraph({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.4)),
    );
  }
}
