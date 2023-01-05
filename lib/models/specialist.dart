import 'package:cloud_firestore/cloud_firestore.dart';

class Specialist {
  final String id;
  final String specialistname;

  Specialist({
    required this.id,
    required this.specialistname,
  });

  factory Specialist.fromFireStore(DocumentSnapshot doc) {
    return Specialist(id: doc['id'], specialistname: doc['specialistname']);
  }
}
