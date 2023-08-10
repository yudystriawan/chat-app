import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

late GetIt getIt;

@InjectableInit(
  asExtension: false,
  preferRelativeImports: true,
)
void configureDependencies(GetIt instance) {
  init(instance);
  getIt = instance;
}
