import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nhbp/core/viewmodel/controllervm.dart';
import 'package:nhbp/core/viewmodel/loadervm.dart';
import 'package:nhbp/core/viewmodel/loginvm.dart';

final loaderVM = ChangeNotifierProvider((_) => LoaderVM());
final controllerVM = ChangeNotifierProvider((_) => ControllerViewModel());
final loginVM = ChangeNotifierProvider((_) => LoginViewModel());
