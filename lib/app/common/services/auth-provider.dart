import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/common/services/auth.dart';

class AuthProvider extends InheritedWidget {
  AuthProvider({@required this.auth, @required this.child});
  final AuthBase auth;
  final Widget child;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static AuthBase of(BuildContext context) {
    AuthProvider provider = context.inheritFromWidgetOfExactType(AuthProvider);
    return provider.auth;
  }
}
