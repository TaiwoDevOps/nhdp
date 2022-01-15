import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nhbp/core/providers.dart';
import 'package:nhbp/presentation/journey/auth/login_page.dart';
import 'package:pedantic/pedantic.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  runApp(Phoenix(child: ProviderScope(child: MyApp())));
}

class MyApp extends HookWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    var vm = useProvider(loaderVM);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      /* set Status bar color in Android devices. */
      statusBarColor: Colors.transparent,
      /* set Status bar icons color in Android devices.*/
      statusBarIconBrightness: Brightness.dark,
      /* set Status bar icon color in iOS. */
      statusBarBrightness:
          (Platform.isIOS ? Brightness.light : Brightness.dark),
      systemNavigationBarColor: AppColor.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'APP NAME',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigator.key,
      navigatorObservers: [],
      builder: (context, child) {
        return Scaffold(
          // Global scaffold used to show SnackBars
          body: vm.isLoading
              ? Container(
                  child: Stack(
                    children: [
                      child!,
                      AbsorbPointer(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.65),
                          child: Center(
                              child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 8,
                              width: 0.25,
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.white12,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            ),
                          )),
                        ),
                      )
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    hideKeyboard(context);
                  },
                  child: child,
                ),
        );
      },
      home: LoginPage(),
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
