import 'package:chat_app/injection.config.dart';
import 'package:core/core.dart';
import 'package:core/core.module.dart';
import 'package:injectable/injectable.dart';

@InjectableInit(externalPackageModulesBefore: [
  ExternalModule(CorePackageModule),
])
Future<void> configurableDependencies() async => getIt.init();
