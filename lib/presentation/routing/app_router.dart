import 'package:go_router/go_router.dart';
import 'package:test2/presentation/pages/my_souvenir_list/my_souvenir_list_page.dart';
import 'package:test2/presentation/pages/my_souvenir_detail/my_souvenir_detail_page.dart';
import 'package:test2/presentation/pages/my_souvenir_form/my_souvenir_form_page.dart';

/// アプリケーションルーター
final appRouter = GoRouter(
  initialLocation: MySouvenirListPage.path,
  routes: [
    GoRoute(
      path: MySouvenirListPage.path,
      name: MySouvenirListPage.name,
      builder: (context, state) => const MySouvenirListPage(),
      routes: [
        GoRoute(
          path: 'form',
          name: MySouvenirFormPage.name,
          builder: (context, state) => const MySouvenirFormPage(),
        ),
        GoRoute(
          path: ':id',
          name: MySouvenirDetailPage.name,
          builder: (context, state) {
            // TODO: ID からお土産を取得
            // final id = state.pathParameters['id'];
            return MySouvenirDetailPage(souvenir: state.extra as dynamic);
          },
        ),
      ],
    ),
  ],
);
