import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:core/observers/bloc_observer.dart';
import 'package:core/services/auth/auth_service.dart';
import 'package:core/services/storage/storage_service.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:core/utils/analytics/analytics.dart';
import 'package:core/utils/routes/observers/route_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'features/account/presentation/blocs/account_actor/account_actor_bloc.dart';
import 'features/account/presentation/blocs/account_watcher/account_watcher_bloc.dart';
import 'features/chat/presentation/blocs/room_actor/room_actor_bloc.dart';
import 'features/chat/presentation/blocs/rooms_watcher/rooms_watcher_bloc.dart';
import 'features/contacts/presentation/blocs/contact_watcher/contact_watcher_bloc.dart';
import 'firebase_options.dart';
import 'injection.dart';
import 'routes/routes.dart';
import 'routes/routes.gr.dart';
import 'shared/bottom_navigation_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // setup dependency injection
  await configurableDependencies();
  await getIt.allReady();

  // setup firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // use firebase emulator when debug
  if (kDebugMode) {
    getIt<FirestoreService>().useEmulator('localhost', 8080);
    getIt<AuthService>().useEmulator('localhost', 9099);
    getIt<StorageService>().useEmulator('localhost', 9199);
  }

  // setup bloc observer
  Bloc.observer = MyBlocObserver();

  // setup analytics
  Analytics.initialize();

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthEvent.watchUserStarted()),
        ),
        BlocProvider(
          create: (context) => getIt<AccountWatcherBloc>()
            ..add(const AccountWatcherEvent.started()),
        ),
        BlocProvider(
          create: (context) => getIt<RoomActorBloc>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp.router(
            routerConfig: _appRouter.config(
              reevaluateListenable: getIt<AuthProvider>(),
              navigatorObservers: () => [AppRouteObserver()],
            ),
            title: 'Chat App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: BrandColor.dark,
                background: NeutralColor.white,
              ),
              useMaterial3: true,
              textTheme: AppTypography.setTextTheme(),
            ),
          );
        },
      ),
    );
  }
}

@RoutePage()
class HomePage extends StatefulWidget implements AutoRouteWrapper {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ContactWatcherBloc>()
            ..add(const ContactWatcherEvent.watchAllStarted()),
        ),
        BlocProvider(
          create: (context) => getIt<RoomsWatcherBloc>()
            ..add(const RoomsWatcherEvent.watchAllStarted()),
        ),
        BlocProvider(
          create: (context) => getIt<AccountActorBloc>(),
        ),
      ],
      child: this,
    );
  }
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late AccountActorBloc accountActorBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    accountActorBloc = context.read<AccountActorBloc>();
    accountActorBloc.add(const AccountActorEvent.onlineStatusChanged(true));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle lifecycle state changes here
    switch (state) {
      case AppLifecycleState.inactive:
        // The app is in an inactive state (e.g., when a phone call is received)
        accountActorBloc
            .add(const AccountActorEvent.onlineStatusChanged(false));
        break;
      case AppLifecycleState.resumed:
        // The app is resumed from the background
        accountActorBloc.add(const AccountActorEvent.onlineStatusChanged(true));
        break;
      case AppLifecycleState.paused:
        // The app is paused (e.g., when it goes into the background)
        accountActorBloc
            .add(const AccountActorEvent.onlineStatusChanged(false));
        break;
      case AppLifecycleState.detached:
        // The app is detached (e.g., when it is terminated)
        accountActorBloc
            .add(const AccountActorEvent.onlineStatusChanged(false));
        break;
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomActorBloc, RoomActorState>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () {},
          addRoomSuccess: (value) =>
              context.pushRoute(RoomRoute(roomId: value.roomId)),
        );
      },
      child: Stack(
        children: [
          AutoTabsScaffold(
            routes: const [
              ContactsRoute(),
              ChatRoute(),
              PreferencesRoute(),
            ],
            bottomNavigationBuilder: (context, tabsRouter) {
              return AppBottomNavigationBar(
                activeIndex: tabsRouter.activeIndex,
                onNavPressed: (index) => tabsRouter.setActiveIndex(index),
              );
            },
          ),
          BlocBuilder<RoomActorBloc, RoomActorState>(
            builder: (context, state) {
              return state.maybeMap(
                orElse: () => const SizedBox(),
                actionInProgress: (_) => Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
