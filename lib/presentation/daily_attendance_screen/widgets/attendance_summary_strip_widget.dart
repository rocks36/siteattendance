import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class AttendanceSummaryStripWidget extends StatelessWidget {
  final int presentCount;
  final int absentCount;
  final int halfDayCount;
  final int leaveCount;
  final double totalWageCost;

  const AttendanceSummaryStripWidget({
    required this.presentCount,
    required this.absentCount,
    required this.halfDayCount,
    required this.leaveCount,
    required this.totalWageCost,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SummaryChip(
              count: presentCount,
              label: 'Present',
              color: AppTheme.statusPresent,
              bgColor: AppTheme.successLight,
            ),
            _Divider(),
            _SummaryChip(
              count: absentCount,
              label: 'Absent',
              color: AppTheme.statusAbsent,
              bgColor: AppTheme.errorLight,
            ),
            _Divider(),
            _SummaryChip(
              count: halfDayCount,
              label: 'Half Day',
              color: AppTheme.statusHalfDay,
              bgColor: AppTheme.warningLight,
            ),
            _Divider(),
            _SummaryChip(
              count: leaveCount,
              label: 'Leave',
              color: AppTheme.statusLeave,
              bgColor: AppTheme.purpleLight,
            ),
            _Divider(),
            Column(
              children: [
                Text(
                  '₹${totalWageCost.toStringAsFixed(0)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryOrange,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  'Total Cost',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: AppTheme.primaryOrange.withAlpha(179),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  final Color bgColor;

  const _SummaryChip({
    required this.count,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        ),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            color: color.withAlpha(179),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
