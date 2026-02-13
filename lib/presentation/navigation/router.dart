import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/my_plan/my_plan_screen.dart';
import '../screens/health/health_screen.dart';
import '../screens/appointments/appointments_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/my_plan/edit_goals_screen.dart';
import '../screens/my_plan/clinician_profile_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/home/daily_exercise_screen.dart';
import '../screens/home/daily_nutrition_screen.dart';
import '../screens/home/task_detail_screen.dart';
import 'main_shell.dart';

// Keys for navigation
final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

/// Router Provider
final routerProvider = Provider<GoRouter>((ref) {
  final currentAuth = ref.read(authProvider);
  final notifier = ValueNotifier<AuthState>(currentAuth);
  
  ref.onDispose(notifier.dispose);

  ref.listen<AuthState>(authProvider, (_, next) {
    notifier.value = next;
  });

  return GoRouter(
    refreshListenable: notifier,
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final status = authState.status;
      final path = state.uri.path;
      final isLoggedIn = status == AuthStatus.authenticated;
      
      final isLogin = path == '/login';
      final isSignup = path == '/signup';
      final isForgotPassword = path == '/forgot-password';
      final isSplash = path == '/';
      final isPublicRoute = isLogin || isSignup || isSplash || isForgotPassword;

      print('Redirect Check: status=$status, path=$path');
     
      // 1. Initial State -> Always go to Splash
      if (status == AuthStatus.initial) {
        return '/';
      }

      // 2. Verified Error or Loading State -> Stay on current screen
      // This ensures we don't navigate away while showing an error snackbar or loading spinner
      if (status == AuthStatus.error || status == AuthStatus.loading) {
        return null;
      }

      // 3. Authenticated User
      if (isLoggedIn) {
        // If on a public route (Splash/Login/Signup), redirect to Home
        if (isPublicRoute) {
          return '/home';
        }
        // Otherwise, allow access to the protected route they are on
        return null;
      }
      
      // 4. Unauthenticated User
      if (!isLoggedIn) {
        // If strictly on Splash, go to Login
        if (isSplash) {
          return '/login';
        }
        // If on other public routes (Login/Signup/Forgot), stay there
        if (isPublicRoute) {
          return null;
        }
        // If on a protected route, redirect to login
        return '/login';
      }


      return null;

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      // Shell route for main app with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(
            currentPath: state.uri.path,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/my-plan',
            builder: (context, state) => const MyPlanScreen(),
          ),

          GoRoute(
            path: '/health',
            builder: (context, state) => const HealthScreen(),
          ),
          GoRoute(
            path: '/appointments',
            builder: (context, state) => const AppointmentsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/daily-exercise',
            builder: (context, state) => const DailyExerciseScreen(),
          ),
          GoRoute(
            path: '/daily-nutrition',
            builder: (context, state) => const DailyNutritionScreen(),
          ),
          GoRoute(
            path: '/task/:id',
            builder: (context, state) {
              final taskId = state.pathParameters['id'] ?? '';
              return TaskDetailScreen(taskId: taskId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/edit-goals',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const EditGoalsScreen(),
      ),
      GoRoute(
        path: '/clinician-profile',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>?;
          return ClinicianProfileScreen(
            name: extras?['name'] ?? 'Doctor',
            role: extras?['role'] ?? 'Specialist',
            imageUrl: extras?['imageUrl'],
            bio: extras?['bio'],
          );
        },
      ),
    ],
  );
});
