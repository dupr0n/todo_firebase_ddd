import 'package:auto_route/auto_route_annotations.dart';

import '../sign_in/sign_in_page.dart';
import '../splash/splash_page.dart';

@MaterialAutoRouter(
  generateNavigationHelperExtension: true,
  routes: <AutoRoute>[
    MaterialRoute(page: SignInPage),
    MaterialRoute(page: SplashPage, initial: true),
  ],
)
class $Router {}
