import 'package:flutter/material.dart';

import 'package:flutter_time_tracker/app/common/services/auth.dart';

import 'package:flutter_time_tracker/app/common/widgets/platform-exception-alert-dialog.dart';
import 'package:provider/provider.dart';
import '../common/widgets/form-submit-button.dart';
import 'package:flutter/services.dart';

import 'email-sign-in-change-model.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  const EmailSignInFormChangeNotifier({Key key, @required this.model})
      : super(key: key);
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
        builder: (_) => EmailSignInChangeModel(auth: auth),
        child: Consumer<EmailSignInChangeModel>(
          builder: (context, model, _) =>
              EmailSignInFormChangeNotifier(model: model),
        ));
  }

  @override
  EmailSignInFormChangeNotifierState createState() =>
      EmailSignInFormChangeNotifierState();
}

class EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;
  String get _email => _emailController.text;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }

  void _emailEditingComplete() {
    FocusNode next = _emailFocusNode;

    bool emailValid = model.emailValidator.isValid(model.email);
    if (emailValid == true) {
      next = _passwordFocusNode;
    }
    FocusScope.of(context).requestFocus(next);
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 16),
      _buildPasswordTextField(),
      SizedBox(height: 16),
      FormSubmitButton(
          text: model.primaryButtonText,
          onPressed: model.canSubmit ? _submit : null),
      SizedBox(height: 8),
      FlatButton(
          child: Text(model.secondaryButtonText),
          onPressed: model.isLoading == true ? null : _toggleFormType)
    ];
  }

  Widget _buildEmailTextField() {
    return TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          hintText: 'test@example.com',
          labelText: 'Email',
          errorText: model.emailErrorText,
          enabled: model.isLoading == false,
        ),
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => _emailEditingComplete(),
        onChanged: (value) => model.updateWith(email: value));
  }

  Widget _buildPasswordTextField() {
    return TextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'password',
          labelText: 'Password',
          errorText: model.passwordErrorText,
          enabled: model.isLoading == false,
        ),
        textInputAction: TextInputAction.done,
        onEditingComplete: _submit,
        onChanged: (value) => model.updateWith(password: value));
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
