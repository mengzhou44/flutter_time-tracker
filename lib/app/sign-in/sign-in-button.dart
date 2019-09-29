import 'package:flutter/material.dart';
import '../common-widgets/custom-raised-button.dart';

class SignInButton extends CustomRaisedButton {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;
  final Image logo;

  static List<Widget> createChildren(text, textColor, logo) {
    final child = Text(
      text,
      style: TextStyle(color: textColor, fontSize: 15),
    );
    if (logo == null) {
      return [child];
    }

    return [logo, child, Opacity(child: logo, opacity: 0)];
  }

  SignInButton(
      {this.text, this.color, this.textColor, this.onPressed, this.logo})
      : super(
            child: Row(
              children: createChildren(text, textColor, logo),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            color: color,
            onPressed: onPressed,
            borderRadius: 8.0,
            height: 50.0);
}
