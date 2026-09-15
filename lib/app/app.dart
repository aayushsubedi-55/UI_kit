import 'package:flutter/material.dart';
import 'package:pracproj/app/routes/app_routes.dart';

import 'l10n/generated/app_localizations.dart';
// import 'routes/screen_paths.dart';
// import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'pracproj',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      // initialRoute: AppRoutes.splash,
      // onGenerateRoute: AppRouter.onGenerateRoute,
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
