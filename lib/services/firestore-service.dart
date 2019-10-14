import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  Future<void> setData({@required  Map<String, dynamic> data,@required String path}) async {
    final documentReference = Firestore.instance.document(path);
    await documentReference.setData(data);
  }

  Future<void> deleteData({@required  String path}) async {
    final documentReference = Firestore.instance.document(path);
    await documentReference.delete();
  }

  Stream<List<T>> collectionStream<T>(
      {@required String path,
      @required T builder(Map<String, dynamic> map, String documentId)}) {
    final documentReference = Firestore.instance.collection(path);
    final snapshots = documentReference.snapshots();

    return snapshots.map((snapshot) => snapshot.documents
        .map((document) => builder(document.data, document.documentID))
        .toList());
  }
}
