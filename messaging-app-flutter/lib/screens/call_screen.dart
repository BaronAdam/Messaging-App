import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messaging_app_flutter/components/round_icon_button.dart';
import 'package:messaging_app_flutter/helpers/screen_arguments.dart';
import 'package:signalr_client/hub_connection.dart';

class CallScreen extends StatefulWidget {
  static const String id = 'call_screen';

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  static const duration = const Duration(seconds: 1);

  Timer timer;
  int secondsPassed = 0;

  int seconds = 0;
  int minutes = 0;
  int hours = 0;

  bool isFirstTime = true;

  bool isOnSpeaker = false;
  bool isMicrophoneMuted = false;
  bool isInCall = false;

  HubConnection hubConnection;

  @override
  void initState() {
    if (timer == null)
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });
    super.initState();
  }

  @override
  void dispose() {
    hubConnection.off('callAccepted');
    hubConnection.off('callDeclined');
    hubConnection.off('receiveSignal');
    hubConnection.off('callEnded');
    super.dispose();
  }

  void handleTick() {
    if (!mounted) return;
    setState(() {
      secondsPassed++;
      seconds = secondsPassed % 60;
      minutes = secondsPassed ~/ 60;
      hours = secondsPassed ~/ (60 * 60);
    });
  }

  @override
  Widget build(BuildContext context) {
    final CallScreenArguments args = ModalRoute.of(context).settings.arguments;
    String otherPersonId = args.otherPersonId;
    String otherPersonName = args.otherPersonName;
    hubConnection = args.hubConnection;
    bool answerCall = args.shouldSendCallAnswer;

    if (isFirstTime) {
      isFirstTime = false;

      hubConnection.on('callAccepted', (data) {
        var acceptingUser = data[0];
        //TODO: setup webRTC
        setState(() {
          secondsPassed = 0;
          seconds = 0;
          minutes = 0;
          isInCall = true;
        });
      });

      hubConnection.on('callDeclined', (data) {
        Navigator.pop(context);
      });

      hubConnection.on('receiveSignal', (data) {
        var signalingUser = data[0];
        var signal = data[1];

        //TODO: webRTC
      });

      hubConnection.on('callEnded', (data) {
        //TODO: webRTC close

        try {
          Navigator.pop(context);
        } catch (e) {
          print(e);
        }
      });

      if (answerCall) {
        hubConnection.invoke(
          'AnswerCall',
          args: <Object>[true, int.parse(otherPersonId)],
        );
        setState(() {
          isInCall = true;
        });
      } else {
        hubConnection.invoke(
          'callUser',
          args: <Object>[int.parse(otherPersonId)],
        );
      }
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
                    otherPersonName,
                    style: TextStyle(
                        fontSize: 42,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    isInCall
                        ? formatTime(hours, minutes, seconds)
                        : 'Calling...',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      isOnSpeaker
                          ? RoundIconButton(
                              onPressed: () {
                                setState(() {
                                  isOnSpeaker = false;
                                });
                              },
                              fillColor: Colors.white,
                              borderColor: Colors.white,
                              icon: Icon(
                                Icons.volume_up,
                                color: Colors.black,
                              ),
                              isElevated: true)
                          : RoundIconButton(
                              onPressed: () {
                                setState(() {
                                  isOnSpeaker = true;
                                });
                              },
                              fillColor: Color(0),
                              borderColor: Colors.white,
                              icon: Icon(
                                Icons.volume_up,
                                color: Colors.white,
                              ),
                              isElevated: false),
                      Spacer(),
                      RoundIconButton(
                        icon: Icon(
                          Icons.call_end,
                          color: Colors.white,
                        ),
                        fillColor: Colors.red[800],
                        borderColor: Colors.red[800],
                        onPressed: () {
                          hubConnection.invoke('hangUp');
                          Navigator.pop(context);
                        },
                        isElevated: true,
                      ),
                      Spacer(),
                      isMicrophoneMuted
                          ? RoundIconButton(
                              onPressed: () {
                                setState(() {
                                  isMicrophoneMuted = false;
                                });
                              },
                              fillColor: Colors.white,
                              borderColor: Colors.white,
                              icon: Icon(
                                Icons.mic_off,
                                color: Colors.black,
                              ),
                              isElevated: true)
                          : RoundIconButton(
                              onPressed: () {
                                setState(() {
                                  isMicrophoneMuted = true;
                                });
                              },
                              fillColor: Color(0),
                              borderColor: Colors.white,
                              icon: Icon(
                                Icons.mic_off,
                                color: Colors.white,
                              ),
                              isElevated: false),
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
}

String formatTime(int hours, int minutes, int seconds) {
  String minutesString, secondsString;
  hours == 0
      ? minutesString = minutes.toString()
      : minutesString = minutes < 10 ? '0$minutes' : minutes.toString();

  secondsString = seconds < 10 ? '0$seconds' : seconds.toString();

  return hours == 0
      ? '$minutesString:$secondsString'
      : '$hours:$minutesString:$secondsString';
}

void addMethodsToHub() {}
