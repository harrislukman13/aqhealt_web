import 'package:cloud_firestore/cloud_firestore.dart';

class Appointments {
  DateTime? bookdate;
  int? time;
  String? doctorID;
  String? patientID;

  Appointments({
    this.bookdate,
    this.time,
    this.doctorID,
    this.patientID,
  });

  factory Appointments.fromFirestore(DocumentSnapshot doc) {
    return Appointments(
        bookdate: doc['bookdate'],
        time: doc['time'],
        doctorID: doc['doctorid'],
        patientID: doc['patientid']);
  }
}
