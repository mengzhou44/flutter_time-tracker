import 'package:flutter/services.dart';

import './platform-alert-dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({String title, PlatformException exception})
      : super(
            title: title,
            content: _message(exception),
            defaultActionText: 'Ok');

  static String _message(PlatformException e) {
    if (e.message == 'FIRFirestoreErrorDomain') {
      if (e.code == 'Error 7') {
        return 'Missing or insufficient permissions';
      }
    }

    if (_errors[e.code] != null) {
      return _errors[e.code];
    }
    return e.message;
  }

  static Map<String, String> _errors = {
    "ERROR_WRONG_PASSWORD": "The password is invalid!",
    "ERROR_USER_NOT_FOUND": "The user is not found!"
  };
}

 
