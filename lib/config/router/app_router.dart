import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mensaeria_alv/config/router/app_router_notifier.dart';
import 'package:mensaeria_alv/features/admin/presentation/screens/admin_screen.dart';
import 'package:mensaeria_alv/features/auth/auth.dart';
import 'package:mensaeria_alv/features/auth/presentation/providers/auth_provider.dart';
import 'package:mensaeria_alv/features/delivery/presentation/screens/delivery_screen.dart';
import 'package:mensaeria_alv/features/tareas/presentation/screens/screens.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantala
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Task Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const TasksScreen(),
      ),
      GoRoute(
        path: '/form-task',
        builder: (context, state) => const CreateTaskScreen(),
      ),

      ///* Admin Routes
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminScreen(),
      ),

      ///* Delivery Routes
      GoRoute(
        path: '/delivery',
        builder: (context, state) => const DeliveryScreen(),
      ),
    ],
    redirect: (context, state) async {
      final isGoingTo = state.subloc;
      final authStatus = goRouterNotifier.authStatus;

      final user = goRouterNotifier.user?.roles;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;

        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {}
        if (user!.contains('admin')) {
          if (isGoingTo == '/admin' || isGoingTo == '/form-task') {
            return null;
          }
          return '/admin';
        }

        if (user.contains('delivery')) {
          if (isGoingTo == '/delivery') {
            return null;
          }
          return '/delivery';
        }

        if (isGoingTo == '/' || isGoingTo == '/form-task') {
          return null;
        }
      }

      return '/';
    },
  );
});
