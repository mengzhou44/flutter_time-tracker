import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/common_widgets/form-submit-button.dart';
import 'package:flutter_time_tracker/common_widgets/platform-exception-alert-dialog.dart';
import 'package:flutter_time_tracker/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'email-sign-in-bloc.dart';
import 'email-sign-in-model.dart';

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({Key key, @required this.bloc}) : super(key: key);
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    AuthBase auth = Provider.of<AuthBase>(context);
    return Provider<EmailSignInBloc>(
        builder: (_) => EmailSignInBloc(auth: auth),
        child: Consumer<EmailSignInBloc>(
          builder: (context, bloc, _) => EmailSignInForm(bloc: bloc),
        ),
        dispose: (context, bloc) => bloc.dispose());
  }

  @override
  EmailSignInFormState createState() => EmailSignInFormState();
}

class EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

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
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }

  void _emailEditingComplete(EmailSignInModel model) {
    FocusNode next = _emailFocusNode;

    bool emailValid = model.emailValidator.isValid(_email);
    if (emailValid == true) {
      next = _passwordFocusNode;
    }
    FocusScope.of(context).requestFocus(next);
  }

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _isLoading = false;

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    final submitEnabled = model.emailValidator.isValid(_email) &&
        model.passwordValidator.isValid(_password) &&
        _isLoading == false;

    return [
      _buildEmailTextField(model),
      SizedBox(height: 16),
      _buildPasswordTextField(),
      SizedBox(height: 16),
      FormSubmitButton(
          text: model.primaryButtonText,
          onPressed: submitEnabled ? _submit : null),
      SizedBox(height: 8),
      FlatButton(
          child: Text(model.secondaryButtonText),
          onPressed: _isLoading == true ? null : _toggleFormType)
    ];
  }

  Widget _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration:
          InputDecoration(hintText: 'test@example.com', labelText: 'Email'),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(model),
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        builder: (context, snapshot) {
          return  _buildContent(context, snapshot.data);
        });
  }

  Widget _buildContent(BuildContext context, EmailSignInModel model) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: _buildChildren(model),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }
}
