import 'octopus.dart';

/// {@nodoc}
Octopus? _$octopusSingleton;

/// {@nodoc}
set $octopusSingleton(Octopus octopus) => _$octopusSingleton = octopus;

/// {@nodoc}
Octopus get $octopusSingleton =>
    _$octopusSingleton ?? _singletonNotExistOrDisposed();

/// {@nodoc}
Never _singletonNotExistOrDisposed() => throw ArgumentError(
      'The octopus controller is not exist or disposed.'
          'Try to create the new one or use it after first build.',
      'router_not_exist_or_disposed',
    );
