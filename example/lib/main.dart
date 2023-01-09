import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:octopus/octopus.dart';

import 'src/common/initialization/initialization.dart';
import 'src/common/router/routes.dart';
import 'src/common/util/error_util.dart';
import 'src/common/util/logging.dart';
import 'src/common/widget/app.dart';
import 'src/common/widget/app_error.dart';

void main() => runZonedGuarded<void>(
      () async {
        try {
          // TODO: Logo and splash screen
          // Matiunin Mikhail <plugfox@gmail.com>, 30 December 2022
          await $initializeApp();
        } on Object catch (error, stackTrace) {
          ErrorUtil.logError(error, stackTrace).ignore();
          runApp(const AppError());
          return;
        }
        final router = Octopus(routes: Routes.values);
        runApp(App(routerConfig: router.config));
      },
      severe,
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, message) {
          fine(message);
        },
      ),
    );
