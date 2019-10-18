import 'package:flutter/widgets.dart';
 
import 'package:flutter_time_tracker/app/sign-in/validators.dart';
import 'package:flutter_time_tracker/services/auth.dart';

import 'email-sign-in-model.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel(
      {@required this.auth,
      this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});

  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  String get primaryButtonText {
    if (formType == EmailSignInFormType.signIn) {
      return 'Sign In';
    }
    return 'Create an account';
  }

  String get secondaryButtonText {
    if (formType == EmailSignInFormType.signIn) {
      return 'Need an account? Register';
    }
    return 'Have an account? Sign in';
  }

   String get passwordErrorText {
    bool showErrorText =
        submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }


  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
   }


  Future<void> submit() async {
    updateWith(isLoading: true, submitted: false);

    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  void toggleFormType() {
    var formType = EmailSignInFormType.signIn;
    if (this.formType == EmailSignInFormType.signIn) {
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
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
