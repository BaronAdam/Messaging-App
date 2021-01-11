import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:signalr_client/hub_connection.dart';

import 'package:messaging_app_flutter/components/round_icon_button.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';
import 'package:messaging_app_flutter/screens/call_screen/call_screen.dart';

class AnswerCallScreen extends StatefulWidget {
  static const String id = 'answer_call_string';

  @override
  _AnswerCallScreenState createState() => _AnswerCallScreenState();
}

class _AnswerCallScreenState extends State<AnswerCallScreen> {
  HubConnection hubConnection;
  int id;
  String name;

  @override
  Widget build(BuildContext context) {
    final AnswerCallScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    hubConnection = args.hubConnection;
    Object otherPerson = args.otherPerson;
    var encoded = jsonEncode(otherPerson);
    var decoded = jsonDecode(encoded);

    try {
      name = decoded['name'];
      id = decoded['id'];
    } catch (e) {
      print(e);
      return Text('');
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.indigo[900],
                  Colors.red[900],
                ]),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150.0,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 42,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Incoming call',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      RoundIconButton(
                          onPressed: hangUp,
                          fillColor: Colors.red[800],
                          borderColor: Colors.red[800],
                          icon: Icon(
                            Icons.call_end,
                            color: Colors.white,
                          ),
                          isElevated: true),
                      Spacer(),
                      RoundIconButton(
                          onPressed: answerCall,
                          fillColor: Colors.green[800],
                          borderColor: Colors.green[800],
                          icon: Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                          isElevated: true),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 120.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void hangUp() {
    hubConnection.invoke(
      'AnswerCall',
      args: <Object>[false, id],
    );
    Navigator.pop(context);
  }

  void answerCall() async {
    await Navigator.pushNamed(
      context,
      CallScreen.id,
      arguments: CallScreenArguments(
        id.toString(),
        name,
        hubConnection,
        true,
      ),
    );
    Navigator.pop(context);
  }
}
