import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/common_widgets/platform-alert-dialog.dart';
import 'package:flutter_time_tracker/common_widgets/platform-exception-alert-dialog.dart';
import 'package:flutter_time_tracker/models/job.dart';
import 'package:flutter_time_tracker/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class EditJobPage extends StatefulWidget {
  EditJobPage({Key key, @required this.database, @required this.job})
      : super(key: key);
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context);
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditJobPage(database: database, job: job),
        fullscreenDialog: true));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _ratePerHourFocusNode = FocusNode();

  String _name;
  int _ratePerHour;
  bool _isLoading = false;

  @override
  initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    try {
      this.setState(() {
        _isLoading = true;
      });

      if (_validateAndSaveForm()) {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job.name);
        }
        
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
                  title: 'Operation failed',
                  content: 'pleae chooose a different job name!',
                  defaultActionText: 'Ok')
              .show(context);
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          await widget.database.setJob(
            Job(
              id: id,
              name: _name,
              ratePerHour: _ratePerHour,
            ),
          );
          Navigator.of(context).pop();
        }
      }
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    } finally {
      this.setState(() {
        _isLoading = false;
      });
    }
  }

  void _nameEditingComplete() {
    FocusNode next = _ratePerHourFocusNode;
    FocusScope.of(context).requestFocus(next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Job'), elevation: 2.0, actions: [
        FlatButton(
          child: Text(
            'Save',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          onPressed: _submit,
        )
      ]),
      body: _buildContents(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: _buildFormChildren(),
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job name'),
        focusNode: _nameFocusNode,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
        onEditingComplete: _nameEditingComplete,
        textInputAction: TextInputAction.next,
        enabled: _isLoading == false,
        initialValue: _name,
      ),
      TextFormField(
        focusNode: _ratePerHourFocusNode,
        decoration: InputDecoration(labelText: 'Rate per hour'),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.numberWithOptions(
          decimal: false,
          signed: false,
        ),
        enabled: _isLoading == false,
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        onEditingComplete: _submit,
        initialValue: _ratePerHour == null ? null : '$_ratePerHour',
      ),
    ];
  }
}
