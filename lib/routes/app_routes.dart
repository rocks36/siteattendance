import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/daily_attendance_screen/daily_attendance_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/worker_management_screen/worker_management_screen.dart';
import '../widgets/app_scaffold.dart';

class AppRoutes {
  static const String initial = '/';
  static const String homeScreen = '/home-screen';
  static const String dailyAttendanceScreen = '/daily-attendance-screen';
  static const String workerManagementScreen = '/worker-management-screen';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.initial,
  routes: [
    GoRoute(
      path: AppRoutes.initial,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 280),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.homeScreen,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.dailyAttendanceScreen,
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final date = extra?['date'] as DateTime? ?? DateTime.now();
                return DailyAttendanceScreen(selectedDate: date);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.workerManagementScreen,
              builder: (context, state) => const WorkerManagementScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
