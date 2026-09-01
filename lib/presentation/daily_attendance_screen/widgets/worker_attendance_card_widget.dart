import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/status_badge_widget.dart';
import '../daily_attendance_screen.dart';

class WorkerAttendanceCardWidget extends StatefulWidget {
  final WorkerAttendanceModel worker;
  final ValueChanged<AttendanceStatus> onStatusChanged;
  final ValueChanged<double> onOvertimeChanged;

  const WorkerAttendanceCardWidget({
    required this.worker,
    required this.onStatusChanged,
    required this.onOvertimeChanged,
    super.key,
  });

  @override
  State<WorkerAttendanceCardWidget> createState() =>
      _WorkerAttendanceCardWidgetState();
}

class _WorkerAttendanceCardWidgetState
    extends State<WorkerAttendanceCardWidget> {
  bool _showOvertimeField = false;

  static const List<_StatusOption> _statusOptions = [
    _StatusOption(
      status: AttendanceStatus.present,
      label: 'P',
      fullLabel: 'Present',
    ),
    _StatusOption(
      status: AttendanceStatus.absent,
      label: 'A',
      fullLabel: 'Absent',
    ),
    _StatusOption(
      status: AttendanceStatus.halfDay,
      label: 'HD',
      fullLabel: 'Half Day',
    ),
    _StatusOption(
      status: AttendanceStatus.paidLeave,
      label: 'PL',
      fullLabel: 'Paid Leave',
    ),
    _StatusOption(
      status: AttendanceStatus.unpaidLeave,
      label: 'UL',
      fullLabel: 'Unpaid Leave',
    ),
    _StatusOption(
      status: AttendanceStatus.overtime,
      label: 'OT',
      fullLabel: 'Overtime',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final worker = widget.worker;
    final earnings = worker.calculatedEarnings;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: StatusBadgeWidget.colorFor(worker.status).withAlpha(51),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: worker.imageUrl != null
                      ? CustomImageWidget(
                          imageUrl: worker.imageUrl!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          semanticLabel:
                              'Profile photo of ${worker.name}, ${worker.category}',
                        )
                      : Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrangeLight,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              worker.name.substring(0, 1).toUpperCase(),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryOrange,
                              ),
                            ),
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                // Worker Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              worker.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          StatusBadgeWidget(
                            status: worker.status,
                            compact: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            worker.workerId,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryNavyLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              worker.category,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.secondaryNavy,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'currency_rupee',
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 13,
                          ),
                          Text(
                            '${worker.dailyWage.toStringAsFixed(0)}/day',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Earned: ',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '₹${earnings.toStringAsFixed(0)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: earnings > 0
                                  ? AppTheme.success
                                  : AppTheme.error,
                              fontFeatures: [
                                const FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Status Selector Row
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(14),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _statusOptions.map((opt) {
                final isSelected = worker.status == opt.status;
                final color = StatusBadgeWidget.colorFor(opt.status);
                final bgColor = StatusBadgeWidget.bgColorFor(opt.status);
                return GestureDetector(
                  onTap: () {
                    widget.onStatusChanged(opt.status);
                    setState(() {
                      _showOvertimeField =
                          opt.status == AttendanceStatus.overtime;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? bgColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? color : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      opt.label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? color
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Overtime Hours Input
          if (_showOvertimeField || worker.status == AttendanceStatus.overtime)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 16,
                    color: AppTheme.statusOvertime,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'OT Hours:',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      initialValue: worker.overtimeHours.toString(),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (v) {
                        final hrs = double.tryParse(v) ?? 0;
                        widget.onOvertimeChanged(hrs);
                      },
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: AppTheme.statusOvertime,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '@ ₹${worker.overtimeRate.toStringAsFixed(0)}/hr',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusOption {
  final AttendanceStatus status;
  final String label;
  final String fullLabel;

  const _StatusOption({
    required this.status,
    required this.label,
    required this.fullLabel,
  });
}
