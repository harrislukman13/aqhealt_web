import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  String id;
  String doctorName;
  String description;
  String specialistname;
  String specialistId;
  int startTime;
  int endTime;

  Doctor(
      {required this.id,
      required this.doctorName,
      required this.description,
      required this.specialistname,
      required this.specialistId,
      required this.startTime,
      required this.endTime});

  factory Doctor.fromFireStore(DocumentSnapshot doc) {
    return Doctor(
        id: doc['id'],
        doctorName: doc['doctorname'],
        specialistname: doc['specialistname'],
        specialistId: doc['specialistid'],
        description: doc['description'],
        startTime: doc['starttime'],
        endTime: doc['endtime']);
  }

  static fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doctor) {}
}
