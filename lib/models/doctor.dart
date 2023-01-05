import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  String id;
  String doctorName;
  String specialistId;
  String description;
  String specialistname;
  int startTime;
  int endTime;

  Doctor(
      {required this.id,
      required this.doctorName,
      required this.specialistId,
      required this.description,
      required this.specialistname,
      required this.startTime,
      required this.endTime});

  factory Doctor.fromFireStore(DocumentSnapshot doc) {
    return Doctor(
        id: doc['id'],
        doctorName: doc['doctorname'],
        specialistId: doc['specialistid'],
        specialistname: doc['specialistname'],
        description: doc['description'],
        startTime: int.parse(doc['starttime']),
        endTime: int.parse(doc['endtime']));
  }

  static fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doctor) {}
}
