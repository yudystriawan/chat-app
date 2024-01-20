library core;

import 'package:injectable/injectable.dart';

export 'services/firestore/firestore_service.dart';
export 'utils/di/injection.dart';
export 'utils/errors/failure.dart';
export 'utils/routes/router.dart';

@InjectableInit.microPackage(preferRelativeImports: true)
void initMicroPackage() {}
