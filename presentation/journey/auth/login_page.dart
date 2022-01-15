import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nhbp/core/providers.dart';

class LoginPage extends StatefulHookWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var firstName = useProvider(loginVM.select((v) => v.firstname));

    return Scaffold(
      backgroundColor: Color.fromRGBO(53, 55, 81, 0.06),
      body: ListView(
        children: [
          BuildForm(),
        ],
      ),
    );
  }
}

class BuildForm extends HookWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = useProvider(loginVM);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTextField(
            isEmail: true,
            controller: provider.emailTEC,
            labelText: 'Email Address',
            margin: 20,
            validator: (value) {
              if (value!.isNotEmpty) {
                return null;
              } else if (value.isEmpty) {
                return "Email should not be blank";
              } else {
                return "Please enter a valid email address";
              }
            },
          ),
          CustomTextField(
            controller: provider.passwordTEC,
            isPassword: true,
            labelText: 'Password',
            margin: 20,
            validator: (value) {
              if (value!.isNotEmpty) {
                return null;
              } else if (value.isEmpty) {
                return "Password should not be blank";
              } else {
                return "Please enter a valid Password";
              }
            },
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.dimen_20),
              child: CustomButton(
                text: "Login",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    provider.login();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
