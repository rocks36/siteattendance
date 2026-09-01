import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import './widgets/add_worker_bottom_sheet.dart';
import './widgets/worker_filter_bar_widget.dart';
import './widgets/worker_list_card_widget.dart';
import 'widgets/add_worker_bottom_sheet.dart';
import 'widgets/worker_filter_bar_widget.dart';
import 'widgets/worker_list_card_widget.dart';

enum WorkerStatus { active, archived }

class WorkerModel {
  final String id;
  final String name;
  final String workerId;
  final String category;
  final String site;
  final double dailyWage;
  final double overtimeRate;
  final String mobileNumber;
  final String joiningDate;
  final String? imageUrl;
  WorkerStatus status;
  final String? notes;
  final String address;

  WorkerModel({
    required this.id,
    required this.name,
    required this.workerId,
    required this.category,
    required this.site,
    required this.dailyWage,
    required this.overtimeRate,
    required this.mobileNumber,
    required this.joiningDate,
    this.imageUrl,
    this.status = WorkerStatus.active,
    this.notes,
    this.address = '',
  });

  factory WorkerModel.fromMap(Map<String, dynamic> map) {
    return WorkerModel(
      id: map['id'] as String,
      name: map['name'] as String,
      workerId: map['workerId'] as String,
      category: map['category'] as String,
      site: map['site'] as String,
      dailyWage: (map['dailyWage'] as num).toDouble(),
      overtimeRate: (map['overtimeRate'] as num).toDouble(),
      mobileNumber: map['mobileNumber'] as String,
      joiningDate: map['joiningDate'] as String,
      imageUrl: map['imageUrl'] as String?,
      status: map['status'] == 'archived'
          ? WorkerStatus.archived
          : WorkerStatus.active,
      notes: map['notes'] as String?,
      address: map['address'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'workerId': workerId,
    'category': category,
    'site': site,
    'dailyWage': dailyWage,
    'overtimeRate': overtimeRate,
    'mobileNumber': mobileNumber,
    'joiningDate': joiningDate,
    'imageUrl': imageUrl,
    'status': status == WorkerStatus.archived ? 'archived' : 'active',
    'notes': notes,
    'address': address,
  };
}

class WorkerManagementScreen extends StatefulWidget {
  const WorkerManagementScreen({super.key});

  @override
  State<WorkerManagementScreen> createState() => _WorkerManagementScreenState();
}

class _WorkerManagementScreenState extends State<WorkerManagementScreen> {
  // TODO: Replace with Riverpod/Bloc for production
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _selectedCategory = 'All Categories';
  late List<WorkerModel> _workers;

  final List<Map<String, dynamic>> _workerMaps = [
    {
      'id': '1',
      'name': 'Ramesh Kumar',
      'workerId': 'W-001',
      'category': 'Mason',
      'site': 'House Construction – Sector 15',
      'dailyWage': 750.0,
      'overtimeRate': 120.0,
      'mobileNumber': '9876543210',
      'joiningDate': '15 Mar 2026',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1cb6bc9ac-1777459195001.png',
      'status': 'active',
      'notes': 'Experienced mason, team lead',
      'address': 'Village Rampur, UP',
    },
    {
      'id': '2',
      'name': 'Suresh Patel',
      'workerId': 'W-002',
      'category': 'Labour',
      'site': 'School Building – Phase 2',
      'dailyWage': 600.0,
      'overtimeRate': 100.0,
      'mobileNumber': '9765432109',
      'joiningDate': '20 Mar 2026',
      'imageUrl': null,
      'status': 'active',
      'notes': null,
      'address': '',
    },
    {
      'id': '3',
      'name': 'Mohan Singh',
      'workerId': 'W-003',
      'category': 'Electrician',
      'site': 'Commercial Complex – Block A',
      'dailyWage': 900.0,
      'overtimeRate': 150.0,
      'mobileNumber': '9654321098',
      'joiningDate': '01 Apr 2026',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1a2b21d2d-1788243699721.png',
      'status': 'active',
      'notes': 'Licensed electrician',
      'address': 'Sector 8, Noida',
    },
    {
      'id': '4',
      'name': 'Priya Sharma',
      'workerId': 'W-004',
      'category': 'Supervisor',
      'site': 'House Construction – Sector 15',
      'dailyWage': 1200.0,
      'overtimeRate': 200.0,
      'mobileNumber': '9543210987',
      'joiningDate': '10 Feb 2026',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1f1b943f9-1768155090882.png',
      'status': 'active',
      'notes': 'Site supervisor, 8 years experience',
      'address': 'Laxmi Nagar, Delhi',
    },
    {
      'id': '5',
      'name': 'Dinesh Yadav',
      'workerId': 'W-005',
      'category': 'Plumber',
      'site': 'School Building – Phase 2',
      'dailyWage': 800.0,
      'overtimeRate': 130.0,
      'mobileNumber': '9432109876',
      'joiningDate': '05 May 2026',
      'imageUrl': null,
      'status': 'active',
      'notes': null,
      'address': '',
    },
    {
      'id': '6',
      'name': 'Kavita Reddy',
      'workerId': 'W-006',
      'category': 'Painter',
      'site': 'Commercial Complex – Block A',
      'dailyWage': 650.0,
      'overtimeRate': 110.0,
      'mobileNumber': '9321098765',
      'joiningDate': '12 Jun 2026',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1a2b21d2d-1788243699721.png',
      'status': 'active',
      'notes': null,
      'address': 'Hyderabad, Telangana',
    },
    {
      'id': '7',
      'name': 'Arun Verma',
      'workerId': 'W-007',
      'category': 'Carpenter',
      'site': 'House Construction – Sector 15',
      'dailyWage': 850.0,
      'overtimeRate': 140.0,
      'mobileNumber': '9210987654',
      'joiningDate': '22 Apr 2026',
      'imageUrl': null,
      'status': 'active',
      'notes': 'Good with furniture work',
      'address': '',
    },
    {
      'id': '8',
      'name': 'Lakshmi Devi',
      'workerId': 'W-008',
      'category': 'Labour',
      'site': 'School Building – Phase 2',
      'dailyWage': 550.0,
      'overtimeRate': 90.0,
      'mobileNumber': '9109876543',
      'joiningDate': '18 Mar 2026',
      'imageUrl': null,
      'status': 'active',
      'notes': null,
      'address': '',
    },
    {
      'id': '9',
      'name': 'Santosh Mishra',
      'workerId': 'W-009',
      'category': 'Welder',
      'site': 'Commercial Complex – Block A',
      'dailyWage': 950.0,
      'overtimeRate': 160.0,
      'mobileNumber': '9098765432',
      'joiningDate': '30 Jan 2026',
      'imageUrl': null,
      'status': 'active',
      'notes': 'Structural welder',
      'address': 'Allahabad, UP',
    },
    {
      'id': '10',
      'name': 'Geeta Nair',
      'workerId': 'W-010',
      'category': 'Labour',
      'site': 'House Construction – Sector 15',
      'dailyWage': 580.0,
      'overtimeRate': 95.0,
      'mobileNumber': '9087654321',
      'joiningDate': '08 Jul 2026',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_132bfe29d-1788243700593.png',
      'status': 'archived',
      'notes': 'Completed contract',
      'address': 'Kochi, Kerala',
    },
    {
      'id': '11',
      'name': 'Rajiv Tiwari',
      'workerId': 'W-011',
      'category': 'Mason',
      'site': 'School Building – Phase 2',
      'dailyWage': 720.0,
      'overtimeRate': 115.0,
      'mobileNumber': '8976543210',
      'joiningDate': '25 May 2026',
      'imageUrl': null,
      'status': 'active',
      'notes': null,
      'address': '',
    },
    {
      'id': '12',
      'name': 'Anjali Gupta',
      'workerId': 'W-012',
      'category': 'Supervisor',
      'site': 'Commercial Complex – Block A',
      'dailyWage': 1100.0,
      'overtimeRate': 180.0,
      'mobileNumber': '8865432109',
      'joiningDate': '14 Feb 2026',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1a2b21d2d-1788243699721.png',
      'status': 'active',
      'notes': 'QA supervisor',
      'address': 'Pune, Maharashtra',
    },
  ];

  @override
  void initState() {
    super.initState();
    _workers = _workerMaps.map(WorkerModel.fromMap).toList();
  }

  List<WorkerModel> get _filteredWorkers {
    var filtered = _workers.where((w) {
      // Status filter
      if (_selectedFilter == 'Active' && w.status != WorkerStatus.active) {
        return false;
      }
      if (_selectedFilter == 'Archived' && w.status != WorkerStatus.archived) {
        return false;
      }
      // Category filter
      if (_selectedCategory != 'All Categories' &&
          w.category != _selectedCategory) {
        return false;
      }
      // Search
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!w.name.toLowerCase().contains(q) &&
            !w.workerId.toLowerCase().contains(q) &&
            !w.category.toLowerCase().contains(q) &&
            !w.site.toLowerCase().contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();
    return filtered;
  }

  void _archiveWorker(String id) {
    setState(() {
      final idx = _workers.indexWhere((w) => w.id == id);
      if (idx != -1) _workers[idx].status = WorkerStatus.archived;
    });
    Fluttertoast.showToast(
      msg: 'Worker archived',
      backgroundColor: AppTheme.warning,
      textColor: Colors.white,
    );
  }

  void _reactivateWorker(String id) {
    setState(() {
      final idx = _workers.indexWhere((w) => w.id == id);
      if (idx != -1) _workers[idx].status = WorkerStatus.active;
    });
    Fluttertoast.showToast(
      msg: 'Worker reactivated',
      backgroundColor: AppTheme.success,
      textColor: Colors.white,
    );
  }

  void _deleteWorker(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Worker'),
        content: const Text(
          'This will permanently delete the worker and all their attendance records. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _workers.removeWhere((w) => w.id == id));
              Fluttertoast.showToast(
                msg: 'Worker deleted',
                backgroundColor: AppTheme.error,
                textColor: Colors.white,
              );
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddWorkerSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddWorkerBottomSheet(
        onWorkerAdded: (worker) {
          setState(() => _workers.insert(0, worker));
          Fluttertoast.showToast(
            msg: '${worker.name} added successfully',
            backgroundColor: AppTheme.success,
            textColor: Colors.white,
          );
        },
        existingCount: _workers.length,
      ),
    );
  }

  void _showEditWorkerSheet(WorkerModel worker) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddWorkerBottomSheet(
        existingWorker: worker,
        onWorkerAdded: (updated) {
          setState(() {
            final idx = _workers.indexWhere((w) => w.id == updated.id);
            if (idx != -1) _workers[idx] = updated;
          });
          Fluttertoast.showToast(
            msg: '${updated.name} updated',
            backgroundColor: AppTheme.success,
            textColor: Colors.white,
          );
        },
        existingCount: _workers.length,
      ),
    );
  }

  int get _activeCount =>
      _workers.where((w) => w.status == WorkerStatus.active).length;
  int get _archivedCount =>
      _workers.where((w) => w.status == WorkerStatus.archived).length;

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
            // App Bar
            Container(
              color: theme.colorScheme.surface,
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Worker Management',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '$_activeCount active · $_archivedCount archived',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.sort_rounded),
                    tooltip: 'Sort',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert_rounded),
                    tooltip: 'More',
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TextFormField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search by name, ID, category, or site...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
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
            // Filter Bar
            WorkerFilterBarWidget(
              selectedFilter: _selectedFilter,
              selectedCategory: _selectedCategory,
              activeCount: _activeCount,
              archivedCount: _archivedCount,
              onFilterChanged: (f) => setState(() => _selectedFilter = f),
              onCategoryChanged: (c) => setState(() => _selectedCategory = c),
            ),
            // Stats Row
            _WorkerStatsRow(workers: _workers),
            const SizedBox(height: 4),
            // Worker List
            Expanded(
              child: filtered.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.person_search_rounded,
                      title: 'No Workers Found',
                      message: _searchQuery.isNotEmpty
                          ? 'No workers match "$_searchQuery". Try a different search term.'
                          : 'No workers in this category. Add your first worker to get started.',
                      actionLabel: 'Add Worker',
                      onAction: _showAddWorkerSheet,
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        // TODO: Replace with real data refresh
                        await Future.delayed(const Duration(milliseconds: 500));
                      },
                      color: AppTheme.primaryOrange,
                      child: isTablet
                          ? _buildTabletGrid(filtered)
                          : _buildPhoneList(filtered),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddWorkerSheet,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Worker'),
        backgroundColor: AppTheme.primaryOrange,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildPhoneList(List<WorkerModel> workers) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: workers.length,
      itemBuilder: (context, index) {
        final worker = workers[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 180 + (index * 40).clamp(0, 320)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 16 * (1 - value)),
              child: child,
            ),
          ),
          child: WorkerListCardWidget(
            worker: worker,
            onEdit: () => _showEditWorkerSheet(worker),
            onArchive: worker.status == WorkerStatus.active
                ? () => _archiveWorker(worker.id)
                : () => _reactivateWorker(worker.id),
            onDelete: () => _deleteWorker(worker.id),
          ),
        );
      },
    );
  }

  Widget _buildTabletGrid(List<WorkerModel> workers) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
      ),
      itemCount: workers.length,
      itemBuilder: (context, index) {
        final worker = workers[index];
        return WorkerListCardWidget(
          worker: worker,
          onEdit: () => _showEditWorkerSheet(worker),
          onArchive: worker.status == WorkerStatus.active
              ? () => _archiveWorker(worker.id)
              : () => _reactivateWorker(worker.id),
          onDelete: () => _deleteWorker(worker.id),
        );
      },
    );
  }
}

class _WorkerStatsRow extends StatelessWidget {
  final List<WorkerModel> workers;

  const _WorkerStatsRow({required this.workers});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalDailyWage = workers
        .where((w) => w.status == WorkerStatus.active)
        .fold(0.0, (sum, w) => sum + w.dailyWage);
    final categories = workers.map((w) => w.category).toSet().length;
    final sites = workers.map((w) => w.site).toSet().length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            value: '₹${(totalDailyWage / 1000).toStringAsFixed(1)}K',
            label: 'Daily Wage',
            color: AppTheme.primaryOrange,
          ),
          _VertDivider(),
          _StatItem(
            value: '$categories',
            label: 'Categories',
            color: AppTheme.secondaryNavy,
          ),
          _VertDivider(),
          _StatItem(value: '$sites', label: 'Sites', color: AppTheme.success),
          _VertDivider(),
          _StatItem(
            value:
                '${workers.where((w) => w.status == WorkerStatus.active).length}',
            label: 'Active',
            color: AppTheme.info,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        ),
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

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}