import 'package:go_router/go_router.dart';

import 'pages/login_page.dart';

class AuthRoutes {
  static const login = '/login';
}

List<RouteBase> buildAuthRoutes() {
  return [
    GoRoute(
      path: AuthRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
  ];
}
