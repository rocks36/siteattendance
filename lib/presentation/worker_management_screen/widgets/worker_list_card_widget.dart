import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../worker_management_screen.dart';

class WorkerListCardWidget extends StatelessWidget {
  final WorkerModel worker;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  const WorkerListCardWidget({
    required this.worker,
    required this.onEdit,
    required this.onArchive,
    required this.onDelete,
    super.key,
  });

  static Color _categoryColor(String category) {
    switch (category) {
      case 'Mason':
        return AppTheme.secondaryNavy;
      case 'Labour':
        return const Color(0xFF5D4037);
      case 'Electrician':
        return AppTheme.warning;
      case 'Plumber':
        return AppTheme.info;
      case 'Carpenter':
        return const Color(0xFF558B2F);
      case 'Painter':
        return AppTheme.purple;
      case 'Welder':
        return AppTheme.error;
      case 'Supervisor':
        return AppTheme.primaryOrange;
      default:
        return const Color(0xFF5A5A5A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArchived = worker.status == WorkerStatus.archived;
    final catColor = _categoryColor(worker.category);

    return Dismissible(
      key: Key('worker_${worker.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: isArchived ? AppTheme.success : AppTheme.warning,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isArchived ? Icons.refresh_rounded : Icons.archive_rounded,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              isArchived ? 'Reactivate' : 'Archive',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        onArchive();
        return false;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isArchived
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isArchived
                ? theme.colorScheme.outlineVariant
                : catColor.withAlpha(38),
            width: 1.5,
          ),
          boxShadow: isArchived
              ? []
              : [
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
                  // Avatar with category color ring
                  Stack(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: catColor, width: 2.5),
                        ),
                        child: ClipOval(
                          child: worker.imageUrl != null
                              ? CustomImageWidget(
                                  imageUrl: worker.imageUrl!,
                                  width: 52,
                                  height: 52,
                                  fit: BoxFit.cover,
                                  semanticLabel:
                                      'Profile photo of ${worker.name}, ${worker.category} worker',
                                )
                              : Container(
                                  color: catColor.withAlpha(38),
                                  child: Center(
                                    child: Text(
                                      worker.name.substring(0, 1).toUpperCase(),
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: catColor,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      if (isArchived)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppTheme.warning,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.archive_rounded,
                              size: 9,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
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
                                  color: isArchived
                                      ? theme.colorScheme.onSurfaceVariant
                                      : theme.colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: catColor.withAlpha(31),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                worker.category,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: catColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              worker.workerId,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontFamily: 'monospace',
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.phone_rounded, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              worker.mobileNumber,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: AppTheme.primaryOrange,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                worker.site,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _WageTag(
                              label:
                                  '₹${worker.dailyWage.toStringAsFixed(0)}/day',
                              icon: Icons.payments_rounded,
                              color: AppTheme.primaryOrange,
                            ),
                            const SizedBox(width: 8),
                            _WageTag(
                              label:
                                  '₹${worker.overtimeRate.toStringAsFixed(0)}/hr OT',
                              icon: Icons.schedule_rounded,
                              color: AppTheme.info,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Action Row
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.edit_rounded,
                      label: 'Edit',
                      color: AppTheme.secondaryNavy,
                      onTap: onEdit,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 32,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  Expanded(
                    child: _ActionButton(
                      icon: isArchived
                          ? Icons.refresh_rounded
                          : Icons.archive_rounded,
                      label: isArchived ? 'Reactivate' : 'Archive',
                      color: isArchived ? AppTheme.success : AppTheme.warning,
                      onTap: onArchive,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 32,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete',
                      color: AppTheme.error,
                      onTap: onDelete,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WageTag extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _WageTag({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      splashColor: color.withAlpha(38),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
