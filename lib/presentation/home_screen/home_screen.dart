import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import './widgets/home_attendance_trend_widget.dart';
import './widgets/home_calendar_widget.dart';
import './widgets/home_kpi_cards_widget.dart';
import './widgets/home_today_summary_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TODO: Replace with Riverpod/Bloc for production
  DateTime _selectedMonth = DateTime(2026, 9);
  final DateTime _today = DateTime(2026, 9, 1);

  // Mock data: dates with attendance records
  final Set<DateTime> _datesWithRecords = {
    DateTime(2026, 8, 25),
    DateTime(2026, 8, 26),
    DateTime(2026, 8, 27),
    DateTime(2026, 8, 28),
    DateTime(2026, 8, 29),
    DateTime(2026, 9, 1),
  };

  // KPI mock data
  final int _totalWorkers = 18;
  final int _presentToday = 14;
  final int _absentToday = 3;
  final int _halfDayToday = 1;
  final double _wageCostToday = 9600;
  final double _wageCostMonth = 38400;
  final double _attendancePercent = 77.8;

  void _onDateTapped(DateTime date) {
    context.push(AppRoutes.dailyAttendanceScreen, extra: {'date': date});
  }

  void _onMonthChanged(DateTime newMonth) {
    setState(() => _selectedMonth = newMonth);
  }

  void _showMenuOptions(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _MenuBottomSheet(
        onWorkerManagement: () {
          Navigator.pop(context);
          context.go(AppRoutes.workerManagementScreen);
        },
        onAttendanceReport: () => Navigator.pop(context),
        onPayrollReport: () => Navigator.pop(context),
        onSiteManagement: () => Navigator.pop(context),
        onAddWorker: () {
          Navigator.pop(context);
          context.go(AppRoutes.workerManagementScreen);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: theme.colorScheme.surface,
              elevation: 0,
              scrolledUnderElevation: 2,
              pinned: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SiteAttendance',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'September 2026',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                  tooltip: 'Notifications',
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert_rounded),
                  onPressed: () => _showMenuOptions(context),
                  tooltip: 'More options',
                ),
                const SizedBox(width: 4),
              ],
            ),
            SliverToBoxAdapter(
              child: isTablet
                  ? _buildTabletLayout(theme)
                  : _buildPhoneLayout(theme),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(
            AppRoutes.dailyAttendanceScreen,
            extra: {'date': _today},
          );
        },
        icon: const Icon(Icons.check_circle_outline_rounded),
        label: const Text('Mark Today'),
        backgroundColor: AppTheme.primaryOrange,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildPhoneLayout(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: 8),
        HomeCalendarWidget(
          selectedMonth: _selectedMonth,
          today: _today,
          datesWithRecords: _datesWithRecords,
          onDateTapped: _onDateTapped,
          onMonthChanged: _onMonthChanged,
        ),
        const SizedBox(height: 16),
        HomeKpiCardsWidget(
          totalWorkers: _totalWorkers,
          presentToday: _presentToday,
          absentToday: _absentToday,
          halfDayToday: _halfDayToday,
          wageCostToday: _wageCostToday,
          wageCostMonth: _wageCostMonth,
          attendancePercent: _attendancePercent,
        ),
        const SizedBox(height: 16),
        HomeTodaySummaryWidget(
          presentCount: _presentToday,
          absentCount: _absentToday,
          halfDayCount: _halfDayToday,
          totalWorkers: _totalWorkers,
        ),
        const SizedBox(height: 16),
        HomeAttendanceTrendWidget(),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildTabletLayout(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              children: [
                HomeCalendarWidget(
                  selectedMonth: _selectedMonth,
                  today: _today,
                  datesWithRecords: _datesWithRecords,
                  onDateTapped: _onDateTapped,
                  onMonthChanged: _onMonthChanged,
                ),
                const SizedBox(height: 16),
                HomeAttendanceTrendWidget(),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                HomeKpiCardsWidget(
                  totalWorkers: _totalWorkers,
                  presentToday: _presentToday,
                  absentToday: _absentToday,
                  halfDayToday: _halfDayToday,
                  wageCostToday: _wageCostToday,
                  wageCostMonth: _wageCostMonth,
                  attendancePercent: _attendancePercent,
                ),
                const SizedBox(height: 16),
                HomeTodaySummaryWidget(
                  presentCount: _presentToday,
                  absentCount: _absentToday,
                  halfDayCount: _halfDayToday,
                  totalWorkers: _totalWorkers,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuBottomSheet extends StatelessWidget {
  final VoidCallback onAddWorker;
  final VoidCallback onWorkerManagement;
  final VoidCallback onAttendanceReport;
  final VoidCallback onPayrollReport;
  final VoidCallback onSiteManagement;

  const _MenuBottomSheet({
    required this.onAddWorker,
    required this.onWorkerManagement,
    required this.onAttendanceReport,
    required this.onPayrollReport,
    required this.onSiteManagement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = [
      _MenuItem(
        icon: Icons.person_add_rounded,
        label: 'Add Worker',
        color: AppTheme.primaryOrange,
        onTap: onAddWorker,
      ),
      _MenuItem(
        icon: Icons.people_rounded,
        label: 'Worker Management',
        color: AppTheme.secondaryNavy,
        onTap: onWorkerManagement,
      ),
      _MenuItem(
        icon: Icons.calendar_month_rounded,
        label: 'Attendance Reports',
        color: AppTheme.success,
        onTap: onAttendanceReport,
      ),
      _MenuItem(
        icon: Icons.payments_rounded,
        label: 'Payroll Reports',
        color: AppTheme.info,
        onTap: onPayrollReport,
      ),
      _MenuItem(
        icon: Icons.location_city_rounded,
        label: 'Site Management',
        color: AppTheme.warning,
        onTap: onSiteManagement,
      ),
      _MenuItem(
        icon: Icons.share_rounded,
        label: 'Export Reports',
        color: AppTheme.purple,
        onTap: () => Navigator.pop(context),
      ),
      _MenuItem(
        icon: Icons.backup_rounded,
        label: 'Backup & Restore',
        color: AppTheme.statusOvertime,
        onTap: () => Navigator.pop(context),
      ),
      _MenuItem(
        icon: Icons.settings_rounded,
        label: 'Settings',
        color: const Color(0xFF5A5A5A),
        onTap: () => Navigator.pop(context),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
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
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Quick Actions', style: theme.textTheme.titleMedium),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.color.withAlpha(31),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.color, size: 20),
              ),
              title: Text(
                item.label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: item.onTap,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
