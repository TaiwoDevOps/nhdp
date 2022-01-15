import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:nhbp/core/providers.dart';
import 'package:nhbp/model/login_model.dart';
import 'package:nhbp/presentation/fab_widget.dart';

class Controller extends StatefulHookWidget {
  Controller({required this.loginModel});

  final LoginModel loginModel;
  @override
  _ControllerState createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentScreen =
        useProvider(controllerVM.select((_) => _.currentScreen));

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            currentScreen,
          ],
        ),
        bottomNavigationBar: FABBottomAppBar(
          color: Color(0xFFA6AAB4),
          selectedColor: AppColor.darkPurple,
          notchedShape: CircularNotchedRectangle(),
          items: [
            FABBottomAppBarItem(
                iconData: ImageConstant.homeActive,
                inActiveIconData: ImageConstant.homeInActive),
            FABBottomAppBarItem(
              iconData: ImageConstant.walletActive,
              inActiveIconData: ImageConstant.walletInactive,
            ),
            FABBottomAppBarItem(
                iconData: ImageConstant.activeTransactionHistory,
                inActiveIconData: ImageConstant.transactionHistory),
            FABBottomAppBarItem(
              iconData: ImageConstant.chatInactive,
              inActiveIconData: ImageConstant.chatInactive,
            ),
          ],
        ),
      ),
    );
  }
}
