import 'package:core/core.dart';
import 'package:core/core.module.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

@InjectableInit(externalPackageModulesBefore: [
  ExternalModule(CorePackageModule),
])
Future<void> configurableDependencies() async => getIt.init();
