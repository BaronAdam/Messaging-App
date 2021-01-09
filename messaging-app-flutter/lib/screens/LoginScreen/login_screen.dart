import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:signalr_client/http_connection_options.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:messaging_app_flutter/api/auth.dart';
import 'package:messaging_app_flutter/components/rounded_button.dart';
import 'package:messaging_app_flutter/constants.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';
import 'package:messaging_app_flutter/helpers/show_new_dialog.dart';
import 'package:messaging_app_flutter/screens/AnswerCallScreen/answer_call_screen.dart';
import 'package:messaging_app_flutter/screens/ConversationsScreen/conversations_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _login;
  String _password;
  bool showSpinner = false;
  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

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
                controller: passwordTextController,
                textAlign: TextAlign.center,
                obscureText: true,
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
                title: 'Log In',
                color: kAppColor,
                onPressed: logIn,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logIn() async {
    setState(() {
      showSpinner = true;
    });
    try {
      final String token = await Auth.login(_login, _password);

      handleResponse(token);

      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void handleResponse(token) async {
    if (token == '401') {
      showNewDialog(
        'Could not login',
        'Wrong login or/and password',
        DialogType.WARNING,
        context,
      );
    } else if (token == '500') {
      showNewDialog(
        'Internal server error',
        'A server error occurred while processing your request. Try again later',
        DialogType.ERROR,
        context,
      );
    } else if (token != null) {
      var id = JwtDecoder.decode(token)['nameid'];
      HubConnection hubConnection = await openHubConnection(id, token, context);
      loginTextController.clear();
      passwordTextController.clear();
      Navigator.pushNamed(
        context,
        ConversationsScreen.id,
        arguments: ConversationsScreenArguments(token, id, hubConnection),
      );
    }
  }
}

Future<HubConnection> openHubConnection(userId, token, context) async {
  String url = 'http://$kApiUrl/Caller';

  var options = HttpConnectionOptions(accessTokenFactory: () async => token);

  HubConnection hubConnection =
      HubConnectionBuilder().withUrl(url, options: options).build();

  hubConnection.onclose((error) => print('Connection Closed'));

  hubConnection.on('incomingCall', (callingUser) {
    Navigator.pushNamed(context, AnswerCallScreen.id,
        arguments: AnswerCallScreenArguments(callingUser[0], hubConnection));
  });

  await hubConnection.start();

  hubConnection.invoke("Join", args: <Object>[int.parse(userId)]);

  return hubConnection;
}
