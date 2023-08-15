import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'injection.dart';
import 'routes/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // setup dependency injection
  await configurableDependencies();
  await getIt.allReady();

  // setup firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    debugPrint('build main');
    return BlocProvider(
      create: (context) =>
          getIt<AuthBloc>()..add(const AuthEvent.watchUserStarted()),
      child: MaterialApp.router(
        routerConfig: _appRouter.config(
          reevaluateListenable: getIt<AuthProvider>(),
        ),
        title: 'Chat App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () =>
              context.read<AuthBloc>().add(const AuthEvent.signOut()),
          child: const Text('Sign Out'),
        ),
      ),
    );
  }
}
