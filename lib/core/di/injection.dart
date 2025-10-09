import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
//import 'package:luna_arc_sync/data/repositories/search_repository.dart';
//import 'package:luna_arc_sync/presentation/search/cubit/search_cubit.dart';

import 'injection.config.dart'; // This file will be generated
// Import the new module

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() => getIt.init();