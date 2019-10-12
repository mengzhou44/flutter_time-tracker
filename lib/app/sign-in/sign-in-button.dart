import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/common_widgets/custom-raised-button.dart';
 
class SignInButton extends CustomRaisedButton {
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
      {@required String text,
      @required Color color,
      @required Color textColor,
      @required VoidCallback onPressed,
      Image logo})
      : assert(text != null),
        super(
            child: Row(
              children: createChildren(text, textColor, logo),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            color: color,
            onPressed: onPressed,
            borderRadius: 8.0,
            height: 50.0);
}
