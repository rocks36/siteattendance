import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class AttendanceHeaderWidget extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedSite;
  final ValueChanged<String> onSiteChanged;
  final VoidCallback onBack;
  final VoidCallback? onSave;
  final bool isSaving;

  const AttendanceHeaderWidget({
    required this.selectedDate,
    required this.selectedSite,
    required this.onSiteChanged,
    required this.onBack,
    required this.onSave,
    required this.isSaving,
    super.key,
  });

  static const List<String> _sites = [
    'All Sites',
    'House Construction – Sector 15',
    'School Building – Phase 2',
    'Commercial Complex – Block A',
  ];

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
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String _formatDate(DateTime date) {
    final weekday = _weekdays[date.weekday - 1];
    final month = _months[date.month - 1];
    return '$weekday, ${date.day} $month ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Attendance',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      _formatDate(selectedDate),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSaving)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                FilledButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.save_rounded, size: 18),
                  label: const Text('Save'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              initialValue: selectedSite,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on_rounded, size: 18),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
                isDense: true,
              ),
              items: _sites
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(s, style: theme.textTheme.bodyMedium),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) onSiteChanged(v);
              },
              style: theme.textTheme.bodyMedium,
              icon: const Icon(Icons.expand_more_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
