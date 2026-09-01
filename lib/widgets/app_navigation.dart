import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class _TabSpec {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int? branchIndex;

  const _TabSpec({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.branchIndex,
  });
}

class AppNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigation({required this.navigationShell, super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedVisualIndex = 0;

  static const List<_TabSpec> _tabs = [
    _TabSpec(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      branchIndex: 0,
    ),
    _TabSpec(
      label: 'Attendance',
      icon: Icons.check_circle_outline_rounded,
      selectedIcon: Icons.check_circle_rounded,
      branchIndex: 1,
    ),
    _TabSpec(
      label: 'Workers',
      icon: Icons.people_outline_rounded,
      selectedIcon: Icons.people_rounded,
      branchIndex: 2,
    ),
    _TabSpec(
      label: 'Reports',
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart_rounded,
      branchIndex: null, // stub
    ),
    _TabSpec(
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
      branchIndex: null, // stub
    ),
  ];

  void _onTabTapped(int visualIndex) {
    final tab = _tabs[visualIndex];
    if (tab.branchIndex == null) return; // stub tab — silent ignore
    setState(() => _selectedVisualIndex = visualIndex);
    widget.navigationShell.goBranch(
      tab.branchIndex!,
      initialLocation: tab.branchIndex == widget.navigationShell.currentIndex,
    );
  }

  @override
  void didUpdateWidget(AppNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync visual index with shell branch
    final currentBranch = widget.navigationShell.currentIndex;
    final matchingTab = _tabs.indexWhere((t) => t.branchIndex == currentBranch);
    if (matchingTab != -1 && matchingTab != _selectedVisualIndex) {
      setState(() => _selectedVisualIndex = matchingTab);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NavigationBar(
      selectedIndex: _selectedVisualIndex,
      onDestinationSelected: _onTabTapped,
      backgroundColor: theme.colorScheme.surface,
      indicatorColor: AppTheme.primaryOrangeLight,
      elevation: 8,
      shadowColor: Colors.black.withAlpha(26),
      destinations: _tabs.asMap().entries.map((entry) {
        final i = entry.key;
        final tab = entry.value;
        final isStub = tab.branchIndex == null;
        return NavigationDestination(
          icon: Opacity(opacity: isStub ? 0.4 : 1.0, child: Icon(tab.icon)),
          selectedIcon: Opacity(
            opacity: isStub ? 0.4 : 1.0,
            child: Icon(tab.selectedIcon, color: AppTheme.primaryOrange),
          ),
          label: tab.label,
          enabled: !isStub,
        );
      }).toList(),
    );
  }
}
