import 'package:dartz/dartz.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nhbp/core/viewmodel/loadervm.dart';
import 'package:nhbp/model/login_model.dart';
import 'package:nhbp/network/api/login_api.dart';
import 'package:nhbp/presentation/controller.dart';
import 'package:nhbp/utils/navigator.dart';

class LoginViewModel extends ChangeNotifier {
  final auth = Auth();

  bool isDrawerOpen = false;
  final TextEditingController emailTEC = TextEditingController();
  final TextEditingController passwordTEC = TextEditingController();

  LoginModel? _loginModel;

  LoginModel? get loginModel => _loginModel;

  set loginModel(LoginModel? val) {
    _loginModel = val;
    notifyListeners();
  }

  LoaderVM get loader => navigator.context!.read(loaderVM);

  void drawerHandler(bool val) {
    isDrawerOpen = val;
    notifyListeners();
  }

  //Login Request
  Future login() async {
    loader.isLoading = true;

    var loginREQ = await auth.loginUser(
      email: emailTEC.text,
      password: passwordTEC.text,
    );

    await _handelUserLogin(
      loginREQ,
      email: emailTEC.text,
      pass: passwordTEC.text,
    );

    loader.isLoading = false;
  }

  Future _handelUserLogin(
    Either<Failure, LoginModel> loginREQ, {
    String? email,
    String? pass,
  }) async {
    return loginREQ.fold((l) => _handleError(l), (r) async {
      loginModel = r;

      notifyListeners();
      navigator.context!.navigateReplace(Controller(loginModel: r));
    });
  }

  /// Handle Errors and Exceptions
  void _handleError(error) async {
    var errorString = ((error is Failure) ? error.message : '$error');

    await Fluttertoast.showToast(
        msg: errorString,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  showInfo(_) async {
    await Fluttertoast.showToast(
        msg: _ ?? '',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
