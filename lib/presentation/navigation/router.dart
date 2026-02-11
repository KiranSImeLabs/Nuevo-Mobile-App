import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/splash_screen.dart';

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
      final isSplash = path == '/';
      final isPublicRoute = isLogin || isSignup || isSplash;

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

      // 3. Unauthenticated User
      if (!isLoggedIn) {
        // If strictly on Splash, go to Login
        if (isSplash) {
          return '/login';
        }
        // If on other public routes (Login/Signup), stay there
        if (isLogin || isSignup) {
          return null;
        }
        // If on a protected route, redirect to login
        return '/login';
      }

      // 4. Authenticated User
      if (isLoggedIn) {
        // If on a public route (Splash/Login/Signup), redirect to Home
        if (isPublicRoute) {
          return '/home';
        }
        // Otherwise, allow access to the protected route they are on
        return null;
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
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
