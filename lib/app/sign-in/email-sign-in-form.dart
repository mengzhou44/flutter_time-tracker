import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/common/services/auth-provider.dart';
import 'package:flutter_time_tracker/app/common/services/auth.dart';
import 'package:flutter_time_tracker/app/common/widgets/patform-alert-dialog.dart';
import 'package:flutter_time_tracker/app/sign-in/validators.dart';
import '../common/widgets/form-submit-button.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _isLoading = false;

  void _emailEditingComplete() {
    FocusNode next = _emailFocusNode;

    bool emailValid = widget.emailValidator.isValid(_email);
    if (emailValid == true) {
      next = _passwordFocusNode;
    }
    FocusScope.of(context).requestFocus(next);
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });

    try {
       AuthBase auth =AuthProvider.of(context);

      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPasswprd(_email, _password);
      } else {
        await auth.createUserWithEmailAndPasswprd(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      PlatformAlertDialog(
                title: 'Sign in failed!',
                content: e.toString(),
                defaultActionText: 'Ok')
                .show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      if (_formType == EmailSignInFormType.signIn) {
        _formType = EmailSignInFormType.register;
      } else {
        _formType = EmailSignInFormType.signIn;
      }
    });
    _emailController.clear();
    _passwordController.clear();
  }

  String _getPrimaryText() {
    if (_formType == EmailSignInFormType.signIn) {
      return 'Sign in';
    }
    return 'Create an account';
  }

  String _getSecondaryText() {
    if (_formType == EmailSignInFormType.signIn) {
      return 'Need an account? Register';
    }
    return 'Already have an account? Sign in';
  }

  Widget _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration:
          InputDecoration(hintText: 'test@example.com', labelText: 'Email'),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: true,
      decoration: InputDecoration(hintText: 'password', labelText: 'Password'),
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (value) => setState(() {}),
    );
  }

  List<Widget> _buildChildren() {
    final submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        _isLoading == false;

    return [
      _buildEmailTextField(),
      SizedBox(height: 16),
      _buildPasswordTextField(),
      SizedBox(height: 16),
      FormSubmitButton(
          text: _getPrimaryText(), onPressed: submitEnabled ? _submit : null),
      SizedBox(height: 8),
      FlatButton(
          child: Text(_getSecondaryText()),
          onPressed: _isLoading == true ? null : _toggleFormType)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: _buildChildren(),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }
}
