import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class HomeTodaySummaryWidget extends StatelessWidget {
  final int presentCount;
  final int absentCount;
  final int halfDayCount;
  final int totalWorkers;

  const HomeTodaySummaryWidget({
    required this.presentCount,
    required this.absentCount,
    required this.halfDayCount,
    required this.totalWorkers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Summary",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '01 Sep 2026',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stacked progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  Flexible(
                    flex: presentCount,
                    child: Container(color: AppTheme.statusPresent),
                  ),
                  Flexible(
                    flex: halfDayCount,
                    child: Container(color: AppTheme.statusHalfDay),
                  ),
                  Flexible(
                    flex: absentCount,
                    child: Container(color: AppTheme.statusAbsent),
                  ),
                  Flexible(
                    flex:
                        totalWorkers -
                        presentCount -
                        halfDayCount -
                        absentCount,
                    child: Container(color: theme.colorScheme.outlineVariant),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  color: AppTheme.statusPresent,
                  label: 'Present',
                  count: presentCount,
                ),
              ),
              Expanded(
                child: _SummaryItem(
                  color: AppTheme.statusAbsent,
                  label: 'Absent',
                  count: absentCount,
                ),
              ),
              Expanded(
                child: _SummaryItem(
                  color: AppTheme.statusHalfDay,
                  label: 'Half Day',
                  count: halfDayCount,
                ),
              ),
              Expanded(
                child: _SummaryItem(
                  color: theme.colorScheme.outline,
                  label: 'Not Marked',
                  count:
                      totalWorkers - presentCount - absentCount - halfDayCount,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;

  const _SummaryItem({
    required this.color,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 6),
        Text(
          '$count',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
