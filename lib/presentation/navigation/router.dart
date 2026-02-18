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
import '../screens/health/session_overview_screen.dart';
import '../screens/health/active_session_screen.dart';
import '../screens/health/guided_session_screen.dart';
import '../screens/appointments/appointments_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/my_plan/edit_goals_screen.dart';
import '../screens/my_plan/clinician_profile_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/home/daily_exercise_screen.dart';
import '../screens/home/daily_nutrition_screen.dart';
import '../screens/home/task_detail_screen.dart';
import '../screens/appointments/book_session_screen.dart';
import '../screens/appointments/select_time_screen.dart';
import '../screens/appointments/confirm_booking_screen.dart';
import '../screens/appointments/appointment_details_screen.dart';
import '../screens/appointments/connecting_session_screen.dart';
import '../screens/appointments/connecting_session_screen.dart';
import '../screens/profile/account_settings_screen.dart';
import '../screens/profile/privacy_consent_screen.dart';
import '../screens/profile/payments_screen.dart';
import '../screens/profile/notification_settings_screen.dart';
import '../screens/profile/doctor_list_screen.dart';
import '../screens/profile/support_screen.dart';
import '../../domain/entities/session.dart';
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
    initialLocation: '/', // Revert to default
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
        print('Authenticated. path="$path", isPublicRoute=$isPublicRoute');
        // If on a public route (Splash/Login/Signup), redirect to Home
        if (isPublicRoute) {
          print('Redirecting to /home because public route');
          return '/home';
        }
        // Otherwise, allow access to the protected route they are on
        print('Returning null (allow)');
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
      GoRoute(
        path: '/account-settings',
        builder: (context, state) => const AccountSettingsScreen(),
      ),
      GoRoute(
        path: '/privacy-consent',
        builder: (context, state) => const PrivacyConsentScreen(),
      ),
      GoRoute(
        path: '/payments',
        builder: (context, state) => const PaymentsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: '/doctor-list',
        builder: (context, state) => const DoctorListScreen(),
      ),
      GoRoute(
        path: '/support',
        builder: (context, state) => const SupportScreen(),
      ),
      // Shell route for main app with bottom navigation
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          print('ShellRoute builder: path=${state.uri.path}');
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
            builder: (context, state) {
              print('Appointments route builder called');
              return const AppointmentsScreen();
            },
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
        path: '/book-session',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final session = state.extra as Session;
          return BookSessionScreen(session: session);
        },
      ),
      GoRoute(
        path: '/select-time',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final session = state.extra as Session;
          return SelectTimeScreen(session: session);
        },
      ),
      GoRoute(
        path: '/confirm-booking',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final args = state.extra as BookingConfirmationArgs;
          return ConfirmBookingScreen(args: args);
        },
      ),
      GoRoute(
        path: '/appointment-details',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final args = state.extra as BookingConfirmationArgs;
          return AppointmentDetailsScreen(args: args);
        },
      ),
      GoRoute(
        path: '/connecting-session',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ConnectingSessionScreen(),
      ),
      GoRoute(
            path: '/health/session-overview',
            builder: (context, state) => const SessionOverviewScreen(),
          ),
          GoRoute(
            path: '/health/active-session',
            builder: (context, state) => const ActiveSessionScreen(),
          ),
          GoRoute(
            path: '/health/guided-session',
            builder: (context, state) => const GuidedSessionScreen(),
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
