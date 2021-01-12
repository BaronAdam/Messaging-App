import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:messaging_app_flutter/injection.config.dart';

final getIt = GetIt.instance;

@injectableInit
void configureDependencies() => $initGetIt(getIt);
