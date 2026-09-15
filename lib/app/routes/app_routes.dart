import 'package:go_router/go_router.dart';
import 'package:pracproj/app/routes/screen_paths.dart';
import 'package:pracproj/feature/detail/presentation/screens/detail_page.dart';
import 'package:pracproj/feature/home/screens/home_screen.dart';
import 'package:pracproj/feature/page_not_found/page_not_found.dart';
import 'package:pracproj/feature/splash/screens/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: ScreenPaths.splash,

  routes: [
    GoRoute(
      path: ScreenPaths.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: ScreenPaths.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: ScreenPaths.detail,
      name: 'detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;

        return DetailsPage(id: id);
      },
    ),

    GoRoute(
      path: ScreenPaths.pageNotFound,
      name: 'page-not-found',
      builder: (context, state) =>
          const PageNotFound('Something went wrong', url: '/unknown-page'),
    ),
  ],
);
