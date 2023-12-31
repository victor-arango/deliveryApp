import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mensaeria_alv/config/router/app_router_notifier.dart';
import 'package:mensaeria_alv/features/auth/auth.dart';
import 'package:mensaeria_alv/features/auth/presentation/providers/auth_provider.dart';
import 'package:mensaeria_alv/features/delivery/presentation/screens/delivery_screen.dart';
import 'package:mensaeria_alv/features/delivery/presentation/screens/task_delivery_finish.dart';
import 'package:mensaeria_alv/features/tasks/presentation/screens/screens.dart';
import 'package:mensaeria_alv/features/tasks/presentation/screens/tasks_finish_screen.dart';

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
      GoRoute(
        path: '/task/:id', // /product/new
        builder: (context, state) => TaskScreen(
          taskId: state.params['id'] ?? 'no-id',
        ),
      ),
      GoRoute(
        path: '/taskFinish/:id',
        builder: (context, state) => TaskFinishScreen(
          taskId: state.params['id'] ?? 'no-id',
        ),
      ),

      ///* Delivery Routes
      GoRoute(
        path: '/delivery',
        builder: (context, state) => const DeliveryScreen(),
      ),

      GoRoute(
        path: '/taskFinishDelivery/:id',
        builder: (context, state) => TaskFinishDeliveryScreen(
          taskId: state.params['id'] ?? 'no-id',
        ),
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
          if (isGoingTo == '/' ||
              isGoingTo == '/form-task' ||
              isGoingTo.contains('/task/') ||
              isGoingTo.contains('/taskFinish/')) {
            return null;
          }
          return '/';
        }

        if (user.contains('delivery')) {
          if (isGoingTo == '/delivery' ||
              isGoingTo.contains('/taskFinishDelivery/')) {
            return null;
          }
          return '/delivery';
        }

        if (isGoingTo == '/' ||
            isGoingTo == '/form-task' ||
            isGoingTo.contains('/task/')) {
          return null;
        }
      }

      return '/';
    },
  );
});
