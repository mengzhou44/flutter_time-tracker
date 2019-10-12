import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_time_tracker/services/auth.dart';
 
import 'email-sign-in-model.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});
  final AuthBase auth;

  StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  Future<void> submit() async {
    updateWith(isLoading: true, submitted: false);

    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPasswprd(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPasswprd(
            _model.email, _model.password);
      }
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  void toggleFormType() {
    var formType = EmailSignInFormType.signIn;
    if (_model.formType == EmailSignInFormType.signIn) {
      formType = EmailSignInFormType.register;
    }
    updateWith(
        email: '',
        password: '',
        isLoading: false,
        submitted: false,
        formType: formType);
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    // update model
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    // add updated model to _modelController
    _modelController.add(_model);
  }
}
