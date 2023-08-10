import 'package:core/core.dart' as core;
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configurableDependencies() {
  getIt.init();
  core.configureDependencies(getIt);
}
