import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../worker_management_screen.dart';

class AddWorkerBottomSheet extends StatefulWidget {
  final WorkerModel? existingWorker;
  final ValueChanged<WorkerModel> onWorkerAdded;
  final int existingCount;

  const AddWorkerBottomSheet({
    this.existingWorker,
    required this.onWorkerAdded,
    required this.existingCount,
    super.key,
  });

  @override
  State<AddWorkerBottomSheet> createState() => _AddWorkerBottomSheetState();
}

class _AddWorkerBottomSheetState extends State<AddWorkerBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _mobileCtrl;
  late TextEditingController _workerIdCtrl;
  late TextEditingController _dailyWageCtrl;
  late TextEditingController _overtimeRateCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _notesCtrl;
  late TextEditingController _joiningDateCtrl;

  String _selectedCategory = 'Labour';
  String _selectedSite = 'House Construction – Sector 15';
  bool _isSubmitting = false;

  static const List<String> _categories = [
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

  static const List<String> _sites = [
    'House Construction – Sector 15',
    'School Building – Phase 2',
    'Commercial Complex – Block A',
  ];

  @override
  void initState() {
    super.initState();
    final w = widget.existingWorker;
    _nameCtrl = TextEditingController(text: w?.name ?? '');
    _mobileCtrl = TextEditingController(text: w?.mobileNumber ?? '');
    _workerIdCtrl = TextEditingController(
      text:
          w?.workerId ??
          'W-${(widget.existingCount + 1).toString().padLeft(3, '0')}',
    );
    _dailyWageCtrl = TextEditingController(
      text: w?.dailyWage.toStringAsFixed(0) ?? '600',
    );
    _overtimeRateCtrl = TextEditingController(
      text: w?.overtimeRate.toStringAsFixed(0) ?? '100',
    );
    _addressCtrl = TextEditingController(text: w?.address ?? '');
    _notesCtrl = TextEditingController(text: w?.notes ?? '');
    _joiningDateCtrl = TextEditingController(
      text: w?.joiningDate ?? _todayFormatted(),
    );
    if (w != null) {
      _selectedCategory = w.category;
      _selectedSite = w.site;
    }
  }

  String _todayFormatted() {
    const months = [
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
    final now = DateTime(2026, 9, 1);
    return '${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]} ${now.year}';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _workerIdCtrl.dispose();
    _dailyWageCtrl.dispose();
    _overtimeRateCtrl.dispose();
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    _joiningDateCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    // TODO: Replace with Room/SQLite persistence
    await Future.delayed(const Duration(milliseconds: 400));

    final worker = WorkerModel(
      id:
          widget.existingWorker?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      workerId: _workerIdCtrl.text.trim(),
      category: _selectedCategory,
      site: _selectedSite,
      dailyWage: double.tryParse(_dailyWageCtrl.text) ?? 600,
      overtimeRate: double.tryParse(_overtimeRateCtrl.text) ?? 100,
      mobileNumber: _mobileCtrl.text.trim(),
      joiningDate: _joiningDateCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );

    setState(() => _isSubmitting = false);
    if (mounted) {
      Navigator.pop(context);
      widget.onWorkerAdded(worker);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.existingWorker != null;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollCtrl) {
          return Column(
            children: [
              // Handle + Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          isEditing ? 'Edit Worker' : 'Add New Worker',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Form
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Personal Details
                      _SectionLabel(label: 'Personal Details'),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: _nameCtrl,
                        label: 'Full Name *',
                        hint: 'e.g. Ramesh Kumar',
                        icon: Icons.person_rounded,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Name is required'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              controller: _mobileCtrl,
                              label: 'Mobile Number *',
                              hint: '9876543210',
                              icon: Icons.phone_rounded,
                              keyboardType: TextInputType.phone,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Required';
                                }
                                if (v.trim().length < 10) {
                                  return 'Invalid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildField(
                              controller: _workerIdCtrl,
                              label: 'Worker ID *',
                              hint: 'W-001',
                              icon: Icons.badge_rounded,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: _joiningDateCtrl,
                        label: 'Joining Date',
                        hint: '01 Sep 2026',
                        icon: Icons.calendar_today_rounded,
                      ),
                      const SizedBox(height: 20),
                      // Site & Role
                      _SectionLabel(label: 'Site & Role'),
                      const SizedBox(height: 12),
                      _buildDropdown(
                        label: 'Category *',
                        value: _selectedCategory,
                        items: _categories,
                        icon: Icons.work_rounded,
                        onChanged: (v) =>
                            setState(() => _selectedCategory = v!),
                      ),
                      const SizedBox(height: 12),
                      _buildDropdown(
                        label: 'Site Assignment *',
                        value: _selectedSite,
                        items: _sites,
                        icon: Icons.location_city_rounded,
                        onChanged: (v) => setState(() => _selectedSite = v!),
                      ),
                      const SizedBox(height: 20),
                      // Wage Details
                      _SectionLabel(label: 'Wage Details'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              controller: _dailyWageCtrl,
                              label: 'Daily Wage (₹) *',
                              hint: '600',
                              icon: Icons.payments_rounded,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Required';
                                }
                                if (double.tryParse(v) == null) {
                                  return 'Invalid amount';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildField(
                              controller: _overtimeRateCtrl,
                              label: 'OT Rate (₹/hr) *',
                              hint: '100',
                              icon: Icons.schedule_rounded,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Required';
                                }
                                if (double.tryParse(v) == null) {
                                  return 'Invalid rate';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      // Wage Preview
                      const SizedBox(height: 12),
                      _WagePreviewCard(
                        dailyWage: double.tryParse(_dailyWageCtrl.text) ?? 0,
                        overtimeRate:
                            double.tryParse(_overtimeRateCtrl.text) ?? 0,
                      ),
                      const SizedBox(height: 20),
                      // Optional Details
                      _SectionLabel(label: 'Optional Details'),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: _addressCtrl,
                        label: 'Address',
                        hint: 'Village / City, State',
                        icon: Icons.home_rounded,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: _notesCtrl,
                        label: 'Notes',
                        hint: 'Skills, experience, remarks...',
                        icon: Icons.notes_rounded,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: _isSubmitting ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.primaryOrange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  isEditing ? 'Update Worker' : 'Add Worker',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onChanged: (_) => setState(() {}),
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryOrange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryOrange, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      style: theme.textTheme.bodyMedium,
      icon: const Icon(Icons.expand_more_rounded),
    );
  }
}

class _WagePreviewCard extends StatelessWidget {
  final double dailyWage;
  final double overtimeRate;

  const _WagePreviewCard({required this.dailyWage, required this.overtimeRate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final halfDay = dailyWage * 0.5;
    final withOT2 = dailyWage + (overtimeRate * 2);
    final monthly = dailyWage * 26; // ~26 working days

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryOrangeLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryOrange.withAlpha(51)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calculate_rounded,
                size: 16,
                color: AppTheme.primaryOrange,
              ),
              const SizedBox(width: 6),
              Text(
                'Wage Preview',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.primaryOrange,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _WageItem(
                  label: 'Full Day',
                  value: '₹${dailyWage.toStringAsFixed(0)}',
                ),
              ),
              Expanded(
                child: _WageItem(
                  label: 'Half Day',
                  value: '₹${halfDay.toStringAsFixed(0)}',
                ),
              ),
              Expanded(
                child: _WageItem(
                  label: '+2hr OT',
                  value: '₹${withOT2.toStringAsFixed(0)}',
                ),
              ),
              Expanded(
                child: _WageItem(
                  label: '~Monthly',
                  value: '₹${(monthly / 1000).toStringAsFixed(1)}K',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WageItem extends StatelessWidget {
  final String label;
  final String value;

  const _WageItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryOrangeDark,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.primaryOrange.withAlpha(204),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
