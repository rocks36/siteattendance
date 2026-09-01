import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class HomeKpiCardsWidget extends StatelessWidget {
  final int totalWorkers;
  final int presentToday;
  final int absentToday;
  final int halfDayToday;
  final double wageCostToday;
  final double wageCostMonth;
  final double attendancePercent;

  const HomeKpiCardsWidget({
    required this.totalWorkers,
    required this.presentToday,
    required this.absentToday,
    required this.halfDayToday,
    required this.wageCostToday,
    required this.wageCostMonth,
    required this.attendancePercent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _KpiCard(
                  icon: Icons.people_rounded,
                  iconColor: AppTheme.secondaryNavy,
                  iconBg: AppTheme.secondaryNavyLight,
                  title: 'Total Workers',
                  value: '$totalWorkers',
                  subtitle: 'Registered',
                  valueColor: AppTheme.secondaryNavy,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KpiCard(
                  icon: Icons.check_circle_rounded,
                  iconColor: AppTheme.success,
                  iconBg: AppTheme.successLight,
                  title: 'Present Today',
                  value: '$presentToday',
                  subtitle: 'On site',
                  valueColor: AppTheme.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _KpiCard(
                  icon: Icons.cancel_rounded,
                  iconColor: AppTheme.error,
                  iconBg: AppTheme.errorLight,
                  title: 'Absent Today',
                  value: '$absentToday',
                  subtitle: '$halfDayToday Half Day',
                  valueColor: AppTheme.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KpiCard(
                  icon: Icons.payments_rounded,
                  iconColor: AppTheme.primaryOrange,
                  iconBg: AppTheme.primaryOrangeLight,
                  title: 'Wage Cost Today',
                  value: '₹${wageCostToday.toStringAsFixed(0)}',
                  subtitle:
                      'Month: ₹${(wageCostMonth / 1000).toStringAsFixed(1)}K',
                  valueColor: AppTheme.primaryOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _AttendancePercentCard(
            percent: attendancePercent,
            presentCount: presentToday,
            totalCount: totalWorkers,
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String value;
  final String subtitle;
  final Color valueColor;

  const _KpiCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: valueColor,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendancePercentCard extends StatelessWidget {
  final double percent;
  final int presentCount;
  final int totalCount;

  const _AttendancePercentCard({
    required this.percent,
    required this.presentCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryOrange, AppTheme.primaryOrangeDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withAlpha(77),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Attendance Rate',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withAlpha(217),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${percent.toStringAsFixed(1)}%',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$presentCount of $totalCount workers present',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.white.withAlpha(204),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: percent / 100,
                  strokeWidth: 6,
                  backgroundColor: Colors.white.withAlpha(64),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                Text(
                  '${percent.toInt()}%',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
