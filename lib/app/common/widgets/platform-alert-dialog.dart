import 'dart:io';

import 'package:flutter_time_tracker/app/common/widgets/platform-widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformAlertDialog extends PlatformWidget {
  PlatformAlertDialog({
    @required this.title,
    @required this.content,
    @required this.defaultActionText,
    this.defaultCancelText, 
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  final String title;
  final String content;
  final String defaultActionText;
  final String defaultCancelText;

  Future<bool> show(BuildContext context) async {
    if (Platform.isIOS ==true) {
      return await showCupertinoDialog<bool>(
          context: context,
          builder: (context) => this,
      );
    }
    return await showDialog<bool>(
          context: context,
          builder: (context) => this,
          barrierDismissible: true
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.only(top:16.0),
          child: Text(content),
        ),
        actions: _buildActions(context));
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.only(top:16.0),
          child: Text(content),
        ),
        actions: _buildActions(context));
  }

  List<Widget> _buildActions(BuildContext context) {
     List<Widget> actions = [];

    if (defaultCancelText !=null) {
         actions.add(
              FlatButton(
                      child: Text(defaultCancelText),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    )
         );
    }
    actions.add(
              FlatButton(
                      child: Text(defaultActionText),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    )
         );

    return actions;
  }
}
