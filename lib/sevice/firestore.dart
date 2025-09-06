import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference persons = FirebaseFirestore.instance.collection(
    'persons',
  );

  Future<void> addPerson(String personName, String personEmail, int personAge) {
    return persons.add({
      'personName': personName,
      'personEmail': personEmail,
      'personAge': personAge,
      'Timestamp.now': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getPersons() {
    return persons.orderBy('tqimestamp', descending: true).snapshots();
  }

  Future<Map<String, dynamic>?> getPersonById(String personId) async {
    final doc = await persons.doc(personId).get();
    return (doc.data() as Map<String, dynamic>?) ?? {};
  }
}