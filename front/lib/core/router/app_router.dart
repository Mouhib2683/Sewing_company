import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/landing_page/landing.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/sign_up_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/report/repair_report_screen.dart';
import '../../features/repair/assigned_repair_screen.dart';
import '../../features/repair/repair_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../shared/scaffold/main_shell.dart';

/// Navigation map:
///   /landing                -> first screen (welcome page)
///   /login                  -> authentication screen
///   /signup                 -> account creation screen
///   /home                   -> main application screen
///   /home, /notifications, /profile -> bottom-nav shell
///   /assigned-repair, /repair, /repair-report -> focused full-screen tasks

final GoRouter appRouter = GoRouter(
  initialLocation: '/landing',

  routes: [

    // Landing page (first page shown)
    GoRoute(
      path: '/landing',
      builder: (context, state) => const LandingPage(),
    ),

    // Authentication
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),

    // Optional splash screen
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),


    // Main app shell with bottom navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),

      branches: [

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notifications',
              builder: (context, state) => const NotificationsScreen(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),


    // Repair focused screens
    GoRoute(
      path: '/assigned-repair',
      builder: (context, state) => const AssignedRepairScreen(),
    ),

    GoRoute(
      path: '/repair',
      builder: (context, state) => const RepairScreen(),
    ),

    GoRoute(
      path: '/repair-report',
      builder: (context, state) => const RepairReportScreen(),
    ),
  ],
);