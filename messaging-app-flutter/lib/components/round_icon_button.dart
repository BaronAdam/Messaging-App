import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final onPressed;
  final Color fillColor;
  final Color borderColor;
  final Icon icon;
  final bool isElevated;

  RoundIconButton({
    @required this.onPressed,
    @required this.fillColor,
    @required this.borderColor,
    @required this.icon,
    @required this.isElevated,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      shape: CircleBorder(side: BorderSide(width: 2, color: borderColor)),
      fillColor: fillColor,
      constraints: BoxConstraints.tightFor(width: 66, height: 66),
      elevation: isElevated ? 6 : 0,
      child: icon,
    );
  }
}
