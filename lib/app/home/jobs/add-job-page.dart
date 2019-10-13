import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/common_widgets/platform-exception-alert-dialog.dart';
import 'package:flutter_time_tracker/models/job.dart';
import 'package:flutter_time_tracker/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class AddJobPage extends StatefulWidget {
  AddJobPage({Key key, @required this.database}) : super(key: key);
  final Database database;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context);
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddJobPage(
              database: database,
            ),
        fullscreenDialog: true));
  }

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _ratePerHourFocusNode = FocusNode();

  String _name;
  int _ratePerHour;
  bool _isLoading =false; 

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
          this.setState((){
            _isLoading= true;
          });
          
          if (_validateAndSaveForm()) {
              
                await widget.database.createJob(
                  Job(
                    name: _name,
                    ratePerHour: _ratePerHour,
                  ),
                );
                Navigator.of(context).pop();
          }
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
    finally {
        this.setState((){
            _isLoading= false;
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
          focusNode:  _nameFocusNode,
          validator: (value) =>
              value.isNotEmpty ? null : 'Name can\'t be empty',
          onSaved: (value) => _name = value,
          onEditingComplete: _nameEditingComplete,
          textInputAction: TextInputAction.next,
          enabled: _isLoading == false,
          ),
      TextFormField(
        focusNode:  _ratePerHourFocusNode,
        decoration: InputDecoration(labelText: 'Rate per hour'),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.numberWithOptions(
          decimal: false,
          signed: false,
        ),

        enabled: _isLoading == false,
        onSaved: (value) => _ratePerHour = int.parse(value) ?? 0,
        onEditingComplete: _submit
      ),
    ];
  }
}
