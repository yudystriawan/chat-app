import 'package:auto_route/auto_route.dart';
import 'package:core/utils/routes/router.gm.dart';

export './guards/auth_guard.dart';
export './observers/route_observer.dart';

@AutoRouterConfig.module()
class CoreRouter extends $CoreRouter {}
