import 'package:chat_app/injection.config.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

@InjectableInit()
Future<void> configurableDependencies() async => getIt.init();
