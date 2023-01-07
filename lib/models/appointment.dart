import 'package:cloud_firestore/cloud_firestore.dart';

class Appointments {
  String? bookdate;
  int? time;
  String? doctorname;
  String? patientID;

  Appointments({
    this.bookdate,
    this.time,
    this.doctorname,
    this.patientID,
  });

  factory Appointments.fromFirestore(DocumentSnapshot doc) {
    return Appointments(
        bookdate: doc['bookdate'],
        doctorname: doc['doctorname'],
        time: doc['time'],
        patientID: doc['patientid']);
  }
}
