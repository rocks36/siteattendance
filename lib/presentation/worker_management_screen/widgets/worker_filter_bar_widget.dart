import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class WorkerFilterBarWidget extends StatelessWidget {
  final String selectedFilter;
  final String selectedCategory;
  final int activeCount;
  final int archivedCount;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onCategoryChanged;

  const WorkerFilterBarWidget({
    required this.selectedFilter,
    required this.selectedCategory,
    required this.activeCount,
    required this.archivedCount,
    required this.onFilterChanged,
    required this.onCategoryChanged,
    super.key,
  });

  static const List<String> _categories = [
    'All Categories',
    'Labour',
    'Mason',
    'Electrician',
    'Plumber',
    'Carpenter',
    'Painter',
    'Welder',
    'Supervisor',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Status Filter Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              _FilterChip(
                label: 'All',
                count: activeCount + archivedCount,
                isSelected: selectedFilter == 'All',
                onTap: () => onFilterChanged('All'),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Active',
                count: activeCount,
                isSelected: selectedFilter == 'Active',
                onTap: () => onFilterChanged('Active'),
                activeColor: AppTheme.success,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Archived',
                count: archivedCount,
                isSelected: selectedFilter == 'Archived',
                onTap: () => onFilterChanged('Archived'),
                activeColor: AppTheme.warning,
              ),
              const SizedBox(width: 12),
              Container(
                width: 1,
                height: 20,
                color: theme.colorScheme.outlineVariant,
              ),
              const SizedBox(width: 12),
              // Category Dropdown as chip
              GestureDetector(
                onTap: () => _showCategoryPicker(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: selectedCategory != 'All Categories'
                        ? AppTheme.secondaryNavyLight
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selectedCategory != 'All Categories'
                          ? AppTheme.secondaryNavy.withAlpha(77)
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.work_outline_rounded,
                        size: 14,
                        color: selectedCategory != 'All Categories'
                            ? AppTheme.secondaryNavy
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        selectedCategory == 'All Categories'
                            ? 'Category'
                            : selectedCategory,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: selectedCategory != 'All Categories'
                              ? AppTheme.secondaryNavy
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.expand_more_rounded,
                        size: 14,
                        color: selectedCategory != 'All Categories'
                            ? AppTheme.secondaryNavy
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCategoryPicker(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Filter by Category',
              style: theme.textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          ..._categories.map(
            (cat) => ListTile(
              title: Text(cat, style: theme.textTheme.bodyLarge),
              trailing: selectedCategory == cat
                  ? Icon(Icons.check_rounded, color: AppTheme.primaryOrange)
                  : null,
              onTap: () {
                Navigator.pop(context);
                onCategoryChanged(cat);
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? activeColor;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = activeColor ?? AppTheme.primaryOrange;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withAlpha(31)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? color
                    : theme.colorScheme.outline.withAlpha(77),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
