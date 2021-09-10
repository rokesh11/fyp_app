import 'package:cloud_firestore/cloud_firestore.dart';
import 'model.dart';

class FirebaseServices {
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

  //retrieve the data
  Stream<List<Model>> getDataList() {
    return _fireStoreDataBase.collection('violations').snapshots().map((snapShot) =>
        snapShot.docs
            .map((document) => Model.fromJson(document.data(), document.id))
            .toList());
  }

  //upload a data
  Future<void> addData(Model moodData) async {
    DocumentReference docRef =
    await _fireStoreDataBase.collection('violations').add(moodData.toJson());
  }

  //delete a data
  Future<void> deleteData(String docId) async {
    await _fireStoreDataBase.collection('violations').doc(docId).delete();
  }
}
