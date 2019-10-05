import 'package:flutter/material.dart';
import './custom-raised-button.dart';

class FormSubmitButton extends CustomRaisedButton {

  FormSubmitButton(
      {@required String text,
      @required VoidCallback onPressed
      })
      : assert(text != null),
        super(
            child: Text(
                    text,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
            color: Colors.indigo,
            onPressed: onPressed,
            borderRadius: 4.0,
            height: 44.0);
}
