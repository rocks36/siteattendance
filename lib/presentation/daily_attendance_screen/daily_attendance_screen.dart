import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/status_badge_widget.dart';
import './widgets/attendance_header_widget.dart';
import './widgets/attendance_quick_actions_widget.dart';
import './widgets/attendance_summary_strip_widget.dart';
import './widgets/worker_attendance_card_widget.dart';

class WorkerAttendanceModel {
  final String id;
  final String name;
  final String workerId;
  final String category;
  final double dailyWage;
  final double overtimeRate;
  final String? imageUrl;
  AttendanceStatus status;
  double overtimeHours;

  WorkerAttendanceModel({
    required this.id,
    required this.name,
    required this.workerId,
    required this.category,
    required this.dailyWage,
    required this.overtimeRate,
    this.imageUrl,
    this.status = AttendanceStatus.present,
    this.overtimeHours = 0,
  });

  double get calculatedEarnings {
    switch (status) {
      case AttendanceStatus.present:
        return dailyWage + (overtimeHours * overtimeRate);
      case AttendanceStatus.halfDay:
        return dailyWage * 0.5;
      case AttendanceStatus.absent:
        return 0;
      case AttendanceStatus.paidLeave:
        return dailyWage;
      case AttendanceStatus.unpaidLeave:
        return 0;
      case AttendanceStatus.overtime:
        return dailyWage + (overtimeHours * overtimeRate);
    }
  }

  factory WorkerAttendanceModel.fromMap(Map<String, dynamic> map) {
    return WorkerAttendanceModel(
      id: map['id'] as String,
      name: map['name'] as String,
      workerId: map['workerId'] as String,
      category: map['category'] as String,
      dailyWage: (map['dailyWage'] as num).toDouble(),
      overtimeRate: (map['overtimeRate'] as num).toDouble(),
      imageUrl: map['imageUrl'] as String?,
      status: _statusFromString(map['status'] as String),
      overtimeHours: (map['overtimeHours'] as num).toDouble(),
    );
  }

  static AttendanceStatus _statusFromString(String v) {
    switch (v) {
      case 'present':
        return AttendanceStatus.present;
      case 'absent':
        return AttendanceStatus.absent;
      case 'halfDay':
        return AttendanceStatus.halfDay;
      case 'paidLeave':
        return AttendanceStatus.paidLeave;
      case 'unpaidLeave':
        return AttendanceStatus.unpaidLeave;
      case 'overtime':
        return AttendanceStatus.overtime;
      default:
        return AttendanceStatus.present;
    }
  }
}

class DailyAttendanceScreen extends StatefulWidget {
  final DateTime selectedDate;

  const DailyAttendanceScreen({required this.selectedDate, super.key});

  @override
  State<DailyAttendanceScreen> createState() => _DailyAttendanceScreenState();
}

class _DailyAttendanceScreenState extends State<DailyAttendanceScreen> {
  // TODO: Replace with Riverpod/Bloc for production
  String _searchQuery = '';
  String _selectedSite = 'All Sites';
  late List<WorkerAttendanceModel> _workers;
  bool _isSaving = false;

  final List<Map<String, dynamic>> _workerMaps = [
    {
      'id': '1',
      'name': 'Ramesh Kumar',
      'workerId': 'W-001',
      'category': 'Mason',
      'dailyWage': 750.0,
      'overtimeRate': 120.0,
      'imageUrl':
          'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=100',
      'status': 'present',
      'overtimeHours': 0.0,
    },
    {
      'id': '2',
      'name': 'Suresh Patel',
      'workerId': 'W-002',
      'category': 'Labour',
      'dailyWage': 600.0,
      'overtimeRate': 100.0,
      'imageUrl':
          'https://images.pixabay.com/photo/2017/08/01/01/33/beanie-2562646_1280.jpg',
      'status': 'absent',
      'overtimeHours': 0.0,
    },
    {
      'id': '3',
      'name': 'Mohan Singh',
      'workerId': 'W-003',
      'category': 'Electrician',
      'dailyWage': 900.0,
      'overtimeRate': 150.0,
      'imageUrl':
          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=100',
      'status': 'present',
      'overtimeHours': 2.0,
    },
    {
      'id': '4',
      'name': 'Priya Sharma',
      'workerId': 'W-004',
      'category': 'Supervisor',
      'dailyWage': 1200.0,
      'overtimeRate': 200.0,
      'imageUrl':
          'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=100',
      'status': 'present',
      'overtimeHours': 0.0,
    },
    {
      'id': '5',
      'name': 'Dinesh Yadav',
      'workerId': 'W-005',
      'category': 'Plumber',
      'dailyWage': 800.0,
      'overtimeRate': 130.0,
      'imageUrl': null,
      'status': 'halfDay',
      'overtimeHours': 0.0,
    },
    {
      'id': '6',
      'name': 'Kavita Reddy',
      'workerId': 'W-006',
      'category': 'Painter',
      'dailyWage': 650.0,
      'overtimeRate': 110.0,
      'imageUrl':
          'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=100',
      'status': 'paidLeave',
      'overtimeHours': 0.0,
    },
    {
      'id': '7',
      'name': 'Arun Verma',
      'workerId': 'W-007',
      'category': 'Carpenter',
      'dailyWage': 850.0,
      'overtimeRate': 140.0,
      'imageUrl': null,
      'status': 'present',
      'overtimeHours': 0.0,
    },
    {
      'id': '8',
      'name': 'Lakshmi Devi',
      'workerId': 'W-008',
      'category': 'Labour',
      'dailyWage': 550.0,
      'overtimeRate': 90.0,
      'imageUrl':
          'https://images.pixabay.com/photo/2016/11/21/12/42/beard-1845166_1280.jpg',
      'status': 'absent',
      'overtimeHours': 0.0,
    },
    {
      'id': '9',
      'name': 'Santosh Mishra',
      'workerId': 'W-009',
      'category': 'Welder',
      'dailyWage': 950.0,
      'overtimeRate': 160.0,
      'imageUrl': null,
      'status': 'overtime',
      'overtimeHours': 3.0,
    },
    {
      'id': '10',
      'name': 'Geeta Nair',
      'workerId': 'W-010',
      'category': 'Labour',
      'dailyWage': 580.0,
      'overtimeRate': 95.0,
      'imageUrl':
          'https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=100',
      'status': 'unpaidLeave',
      'overtimeHours': 0.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _workers = _workerMaps.map(WorkerAttendanceModel.fromMap).toList();
  }

  List<WorkerAttendanceModel> get _filteredWorkers {
    if (_searchQuery.isEmpty) return _workers;
    final q = _searchQuery.toLowerCase();
    return _workers
        .where(
          (w) =>
              w.name.toLowerCase().contains(q) ||
              w.workerId.toLowerCase().contains(q) ||
              w.category.toLowerCase().contains(q),
        )
        .toList();
  }

  void _markAll(AttendanceStatus status) {
    setState(() {
      for (final w in _workers) {
        w.status = status;
      }
    });
    Fluttertoast.showToast(
      msg: 'All workers marked as ${StatusBadgeWidget.fullLabelFor(status)}',
      backgroundColor: AppTheme.secondaryNavy,
      textColor: Colors.white,
    );
  }

  void _updateWorkerStatus(String id, AttendanceStatus status) {
    setState(() {
      final idx = _workers.indexWhere((w) => w.id == id);
      if (idx != -1) _workers[idx].status = status;
    });
  }

  void _updateOvertimeHours(String id, double hours) {
    setState(() {
      final idx = _workers.indexWhere((w) => w.id == id);
      if (idx != -1) _workers[idx].overtimeHours = hours;
    });
  }

  Future<void> _saveAttendance() async {
    setState(() => _isSaving = true);
    // TODO: Replace with Room/SQLite persistence
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _isSaving = false);
    Fluttertoast.showToast(
      msg: 'Attendance saved successfully',
      backgroundColor: AppTheme.success,
      textColor: Colors.white,
    );
  }

  double get _totalWageCost =>
      _workers.fold(0, (sum, w) => sum + w.calculatedEarnings);
  int get _presentCount => _workers
      .where(
        (w) =>
            w.status == AttendanceStatus.present ||
            w.status == AttendanceStatus.overtime,
      )
      .length;
  int get _absentCount => _workers
      .where(
        (w) =>
            w.status == AttendanceStatus.absent ||
            w.status == AttendanceStatus.unpaidLeave,
      )
      .length;
  int get _halfDayCount =>
      _workers.where((w) => w.status == AttendanceStatus.halfDay).length;
  int get _leaveCount => _workers
      .where(
        (w) =>
            w.status == AttendanceStatus.paidLeave ||
            w.status == AttendanceStatus.unpaidLeave,
      )
      .length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final filtered = _filteredWorkers;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            AttendanceHeaderWidget(
              selectedDate: widget.selectedDate,
              selectedSite: _selectedSite,
              onSiteChanged: (s) => setState(() => _selectedSite = s),
              onBack: () => context.pop(),
              onSave: _isSaving ? null : _saveAttendance,
              isSaving: _isSaving,
            ),
            AttendanceSummaryStripWidget(
              presentCount: _presentCount,
              absentCount: _absentCount,
              halfDayCount: _halfDayCount,
              leaveCount: _leaveCount,
              totalWageCost: _totalWageCost,
            ),
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Search worker name or ID...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 20),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AttendanceQuickActionsWidget(
              onMarkAllPresent: () => _markAll(AttendanceStatus.present),
              onMarkAllAbsent: () => _markAll(AttendanceStatus.absent),
              onMarkAllLeave: () => _markAll(AttendanceStatus.paidLeave),
              onCopyPrevious: () {
                Fluttertoast.showToast(
                  msg: 'Copied attendance from previous day',
                  backgroundColor: AppTheme.info,
                  textColor: Colors.white,
                );
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.search_off_rounded,
                      title: 'No Workers Found',
                      message:
                          'No workers match your search. Try a different name or ID.',
                    )
                  : isTablet
                  ? _buildTabletGrid(filtered)
                  : _buildPhoneList(filtered),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneList(List<WorkerAttendanceModel> workers) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: workers.length,
      itemBuilder: (context, index) {
        final worker = workers[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 200 + (index * 50).clamp(0, 400)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          ),
          child: WorkerAttendanceCardWidget(
            worker: worker,
            onStatusChanged: (status) => _updateWorkerStatus(worker.id, status),
            onOvertimeChanged: (hours) =>
                _updateOvertimeHours(worker.id, hours),
          ),
        );
      },
    );
  }

  Widget _buildTabletGrid(List<WorkerAttendanceModel> workers) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: workers.length,
      itemBuilder: (context, index) {
        final worker = workers[index];
        return WorkerAttendanceCardWidget(
          worker: worker,
          onStatusChanged: (status) => _updateWorkerStatus(worker.id, status),
          onOvertimeChanged: (hours) => _updateOvertimeHours(worker.id, hours),
        );
      },
    );
  }
}
