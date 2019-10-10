import 'package:flutter_time_tracker/app/sign-in/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel  with EmailAndPasswordValidators {
  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});

  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

  String get primaryButtonText  {
       if (formType == EmailSignInFormType.signIn) {
          return  'Sign In';
       }
       return 'Create an account';
  }

  String get secondaryButtonText  {
       if (formType == EmailSignInFormType.signIn) {
          return  'Need an account? Register';
       }
       return 'Have an account? Sign in';
  }

  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
