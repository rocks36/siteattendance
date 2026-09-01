import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class AttendanceQuickActionsWidget extends StatelessWidget {
  final VoidCallback onMarkAllPresent;
  final VoidCallback onMarkAllAbsent;
  final VoidCallback onMarkAllLeave;
  final VoidCallback onCopyPrevious;

  const AttendanceQuickActionsWidget({
    required this.onMarkAllPresent,
    required this.onMarkAllAbsent,
    required this.onMarkAllLeave,
    required this.onCopyPrevious,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          _QuickActionChip(
            icon: Icons.check_circle_rounded,
            label: 'All Present',
            color: AppTheme.statusPresent,
            bgColor: AppTheme.successLight,
            onTap: onMarkAllPresent,
          ),
          const SizedBox(width: 8),
          _QuickActionChip(
            icon: Icons.cancel_rounded,
            label: 'All Absent',
            color: AppTheme.statusAbsent,
            bgColor: AppTheme.errorLight,
            onTap: onMarkAllAbsent,
          ),
          const SizedBox(width: 8),
          _QuickActionChip(
            icon: Icons.beach_access_rounded,
            label: 'All Leave',
            color: AppTheme.statusLeave,
            bgColor: AppTheme.purpleLight,
            onTap: onMarkAllLeave,
          ),
          const SizedBox(width: 8),
          _QuickActionChip(
            icon: Icons.copy_rounded,
            label: 'Copy Previous',
            color: AppTheme.info,
            bgColor: AppTheme.infoLight,
            onTap: onCopyPrevious,
          ),
        ],
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _QuickActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: color.withAlpha(51),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(77)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
