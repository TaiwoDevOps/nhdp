import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:nhbp/core/providers.dart';
import 'package:nhbp/model/login_model.dart';
import 'package:nhbp/utils/navigator.dart';

class ControllerViewModel extends ChangeNotifier {
  static ControllerViewModel get instance =>
      navigator.context!.read(controllerVM);

  //number of screens
  final screens = <Widget>[];

  late LoginModel loginModel;

  Widget get currentScreen => screens[index];

  int _index = 0;
  int get index => _index;
  set index(int val) {
    _index = val;
    notifyListeners();
  }

  bool _showingLogout = false;
  bool get showingLogout => _showingLogout;
  set showingLogout(bool val) {
    _showingLogout = val;
    notifyListeners();
  }

  void bottomTapped(int _) {
    index = _;
  }
}
