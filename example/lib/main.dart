// @dart = 3.0

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
        // TODO(plugfox): Comment
        runApp(const AppError());

        if (1 > 2) {
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
        }
      },
      severe,
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, message) {
          fine(message);
        },
      ),
    );

// Sealed:
/*
  print(calculateArea(Circle(20)));

  sealed class Shape {

  }

  class Square implements Shape {
    final double length;
    Square(this.length);

  }

  class Circle implements Shape {
    final double radius;
    Circle(this.radius);
  }

  double calculateArea(Shape shape) => switch (shape) {
    Square(length: var l) => l * l,
    Circle(radius: var r) => math.pi * r * r
  };
 */