import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/account/presentation/blocs/account_watcher/account_watcher_bloc.dart';
import 'package:chat_app/features/chat/presentation/blocs/room_actor/room_actor_bloc.dart';
import 'package:chat_app/features/contacts/presentation/blocs/contact_watcher/contact_watcher_bloc.dart';
import 'package:chat_app/routes/routes.gr.dart';
import 'package:chat_app/shared/bottom_navigation_bar.dart';
import 'package:core/core.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:core/observers/bloc_observer.dart';
import 'package:core/styles/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'features/chat/presentation/blocs/rooms_watcher/rooms_watcher_bloc.dart';
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

  // setup bloc observer
  Bloc.observer = MyBlocObserver();

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
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp.router(
            routerConfig: _appRouter.config(
              reevaluateListenable: getIt<AuthProvider>(),
            ),
            title: 'Chat App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: BrandColor.dark,
                background: NeutralColor.white,
              ),
              useMaterial3: true,
            ),
          );
        },
      ),
    );
  }
}

@RoutePage()
class HomePage extends StatelessWidget implements AutoRouteWrapper {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomActorBloc, RoomActorState>(
      listener: (context, state) {
        state.map(
          initial: (_) {},
          actionInProgress: (_) {},
          actionFailure: (_) {},
          removeRoomSuccess: (_) {},
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
          create: (context) => getIt<RoomActorBloc>(),
        ),
      ],
      child: this,
    );
  }
}
