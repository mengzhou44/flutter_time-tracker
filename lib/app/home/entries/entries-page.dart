import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/home/jobs/list-items-builder.dart';
import 'package:flutter_time_tracker/services/database.dart';
import 'package:provider/provider.dart';
import 'entry-bloc.dart';
import 'entry-list-tile.dart';
 
class EntriesPage extends StatelessWidget {
  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context);
    return Provider<EntriesBloc>(
      builder: (_) => EntriesBloc(database: database),
      child: EntriesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entries'),
        elevation: 2.0,
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final bloc = Provider.of<EntriesBloc>(context);
    return StreamBuilder<List<EntriesListTileModel>>(
      stream: bloc.entriesTileModelStream,
      builder: (context, snapshot) {
        return ListItemsBuilder<EntriesListTileModel>(
          snapshot: snapshot,
          builder: (context, model) => EntriesListTile(model: model),
        );
      },
    );
  }
}
