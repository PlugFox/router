import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:octopus/octopus.dart';

import '../localization/localization.dart';
import '../router/routes.dart';

/// {@template app}
/// App widget
/// {@endtemplate}
class App extends StatefulWidget {
  /// {@macro app}
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final RouterConfig<Object> routerConfig =
      Octopus(routes: Routes.values).config;

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routerConfig: routerConfig,
        title: 'Encryption',
        restorationScopeId: 'material_app',
        debugShowCheckedModeBanner: false,
        theme: ui.window.platformBrightness == Brightness.dark
            ? ThemeData.dark()
            : ThemeData.light(),
        themeMode: ThemeMode.system,
        localizationsDelegates: const <LocalizationsDelegate<Object?>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          Localization.delegate,
        ],
        supportedLocales: Localization.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: Banner(
            message: 'PREVIEW',
            location: BannerLocation.topEnd,
            child: child,
          ),
        ),
      );
}
