import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class HomeCalendarWidget extends StatelessWidget {
  final DateTime selectedMonth;
  final DateTime today;
  final Set<DateTime> datesWithRecords;
  final ValueChanged<DateTime> onDateTapped;
  final ValueChanged<DateTime> onMonthChanged;

  const HomeCalendarWidget({
    required this.selectedMonth,
    required this.today,
    required this.datesWithRecords,
    required this.onDateTapped,
    required this.onMonthChanged,
    super.key,
  });

  static const List<String> _weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  List<DateTime?> _buildCalendarDays() {
    final firstDay = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final lastDay = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    // Monday = 0 offset
    final startOffset = (firstDay.weekday - 1) % 7;
    final days = <DateTime?>[];
    for (int i = 0; i < startOffset; i++) {
      days.add(null);
    }
    for (int d = 1; d <= lastDay.day; d++) {
      days.add(DateTime(selectedMonth.year, selectedMonth.month, d));
    }
    return days;
  }

  bool _hasRecord(DateTime? date) {
    if (date == null) return false;
    return datesWithRecords.any(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }

  bool _isToday(DateTime? date) {
    if (date == null) return false;
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = _buildCalendarDays();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month Navigation Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
            child: Row(
              children: [
                Text(
                  '${_months[selectedMonth.month - 1]} ${selectedMonth.year}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => onMonthChanged(
                    DateTime(selectedMonth.year, selectedMonth.month - 1),
                  ),
                  icon: const Icon(Icons.chevron_left_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrangeLight,
                    foregroundColor: AppTheme.primaryOrange,
                    minimumSize: const Size(36, 36),
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () => onMonthChanged(
                    DateTime(selectedMonth.year, selectedMonth.month + 1),
                  ),
                  icon: const Icon(Icons.chevron_right_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrangeLight,
                    foregroundColor: AppTheme.primaryOrange,
                    minimumSize: const Size(36, 36),
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
          // Weekday Headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: _weekdays.map((day) {
                final isWeekend = day == 'Sat' || day == 'Sun';
                return Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isWeekend
                            ? AppTheme.primaryOrange.withAlpha(179)
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Calendar Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final date = days[index];
                if (date == null) return const SizedBox();
                final isToday = _isToday(date);
                final hasRecord = _hasRecord(date);
                final isFuture = date.isAfter(today);

                return GestureDetector(
                  onTap: isFuture ? null : () => onDateTapped(date),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isToday
                          ? AppTheme.primaryOrange
                          : hasRecord
                          ? AppTheme.primaryOrangeLight
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${date.day}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: isToday
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isToday
                                ? Colors.white
                                : isFuture
                                ? theme.colorScheme.outline
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        if (hasRecord && !isToday)
                          Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryOrange,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Legend
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                _LegendItem(color: AppTheme.primaryOrange, label: 'Today'),
                const SizedBox(width: 16),
                _LegendItem(
                  color: AppTheme.primaryOrangeLight,
                  label: 'Has Records',
                  border: AppTheme.primaryOrange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final Color? border;

  const _LegendItem({required this.color, required this.label, this.border});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: border != null
                ? Border.all(color: border!, width: 1)
                : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
