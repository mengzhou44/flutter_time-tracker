import 'dart:io';

import 'package:flutter/widgets.dart';

abstract class PlatformWidget  extends StatelessWidget {

  Widget buildCupertinoWidget(BuildContext context);
  Widget buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
       if  (Platform.isIOS == true) {
          return buildCupertinoWidget(context);
       }

        return buildMaterialWidget(context);
  }
}