import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
 
class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  Future<void> setData({Map<String, dynamic> data, String path}) async {
    final documentReference = Firestore.instance.document(path);
    await documentReference.setData(data);
  }

  Stream<List<T>> collectionStream<T>(
      { @required String path, 
        @required T builder(Map<String, dynamic> map)}) {
    
    final documentReference = Firestore.instance.collection(path);
    final snapshots = documentReference.snapshots();

    return snapshots.map((snapshot) =>
        snapshot.documents.map((document) => builder(document.data)).toList());
  }
}
 