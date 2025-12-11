import 'package:go_router/go_router.dart';

import 'pages/counter_page.dart';

class CounterRoutes {
  CounterRoutes._();

  static const String counter = '/counter';
}

List<GoRoute> buildCounterRoutes() => [
  GoRoute(
    path: CounterRoutes.counter,
    builder: (context, state) => const CounterPage(),
  ),
];
