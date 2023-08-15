library core;

import 'package:injectable/injectable.dart';

export 'utils/di/injection.dart';
export 'utils/errors/failure.dart';
export 'utils/routes/router.dart';

@InjectableInit.microPackage()
void initMicroPackage() {}
