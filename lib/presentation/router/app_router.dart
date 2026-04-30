import 'package:go_router/go_router.dart';
import 'package:tienda_app/presentation/screens/add_habit.dart';
import 'package:tienda_app/presentation/screens/login.dart';
import 'package:tienda_app/presentation/screens/main_screen.dart';
import 'package:tienda_app/presentation/screens/profile.dart';
import 'package:tienda_app/presentation/screens/statistics.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login',
    builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/add-habit',
      builder: (context, state) => const AddHabitScreen(),
    ),
    GoRoute(
      path: '/statistics',
      builder: (context, state) => const StatisticsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ]
);