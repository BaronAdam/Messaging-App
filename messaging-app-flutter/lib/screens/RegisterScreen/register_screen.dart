import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:messaging_app_flutter/api/auth.dart';
import 'package:messaging_app_flutter/components/rounded_button.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';
import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/screens/LoginScreen/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String _email;
  String _login;
  String _password;
  String _name;
  bool showSpinner = false;
  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final nameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                controller: loginTextController,
                onChanged: (value) {
                  _login = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Username',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                controller: nameTextController,
                onChanged: (value) {
                  _name = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Name',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                controller: emailTextController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  _email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Email Address',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                controller: passwordTextController,
                onChanged: (value) {
                  _password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  title: 'Register',
                  color: Colors.blueAccent,
                  onPressed: () async {
                    showSpinner = true;
                    var result = '';

                    try {
                      result = await Auth.register(
                        _login,
                        _password,
                        _email,
                        _name,
                      );
                      showSpinner = false;
                    } catch (e) {
                      print(e);
                    }
                    if (result == null) {
                      loginTextController.clear();
                      passwordTextController.clear();
                      emailTextController.clear();
                      nameTextController.clear();
                      Navigator.pushNamed(context, LoginScreen.id);
                    } else if (result == '500') {
                      showNewDialog(
                        'Internal server error',
                        'A server error occurred while processing your request. Try again later',
                        DialogType.ERROR,
                        context,
                      );
                    } else {
                      showNewDialog(
                        'Following errors occurred',
                        result,
                        DialogType.WARNING,
                        context,
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
