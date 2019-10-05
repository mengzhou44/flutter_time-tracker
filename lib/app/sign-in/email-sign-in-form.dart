import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/common/services/auth.dart';
import '../common/widgets/form-submit-button.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget {
  final AuthBase auth;
  EmailSignInForm({this.auth});
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _submit() async {
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPasswprd(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPasswprd(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
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
    final submitEnabled = (_email.isNotEmpty && _password.isNotEmpty);
    return [
      _buildEmailTextField(),
      SizedBox(height: 16),
      _buildPasswordTextField(),
      SizedBox(height: 16),
      FormSubmitButton(
          text: _getPrimaryText(), onPressed: submitEnabled ? _submit : null),
      SizedBox(height: 8),
      FlatButton(child: Text(_getSecondaryText()), onPressed: _toggleFormType)
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
