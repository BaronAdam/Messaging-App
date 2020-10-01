import 'package:awesome_dialog/awesome_dialog.dart';

void showNewDialog(title, text, type, context) {
  AwesomeDialog(
    context: context,
    dialogType: type,
    animType: AnimType.SCALE,
    title: title,
    desc: text,
    btnOkOnPress: () {},
  )..show();
}
