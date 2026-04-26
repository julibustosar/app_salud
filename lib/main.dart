import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_app/data/datasources/habit_remote_datasource.dart';
import 'package:tienda_app/domain/get_habits_use_case.dart';
import 'package:tienda_app/domain/add_habits_use_case.dart';
import 'package:tienda_app/presentation/providers/habit_provider.dart';
import 'package:tienda_app/data/repositories/habit_repository_imp.dart';
import 'package:tienda_app/presentation/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/repositories/auth_repository_imp.dart';
import 'domain/login_use_case.dart';
import 'firebase_options.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final remoteDataSource = HabitRemoteDataSource();
  final repository = HabitRepositoryImp(remoteDataSource);
  final getHabitsUseCase = GetHabitsUseCase(repository);
  final addHabitUseCase = AddHabitsUseCase(repository);
  final authRemoteDataSource = AuthRemoteDataSource();
  final authRepository = AuthRepositoryImp(authRemoteDataSource);
  final loginUseCase = LoginUseCase(authRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HabitProvider(
            getHabitsUseCase: getHabitsUseCase,
            addHabitUseCase: addHabitUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(loginUseCase: loginUseCase),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'App Salud',
      routerConfig: appRouter,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
    );
  }
}