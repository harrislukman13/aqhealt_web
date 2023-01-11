import 'package:cloud_firestore/cloud_firestore.dart';

class Appointments {
  String? bookdate;
  int? time;
  String? doctorname;
  String? patientID;
  String? patientName;
  String? specialistName;
  String? doctorId;

  Appointments(
      {this.bookdate,
      this.time,
      this.doctorname,
      this.patientID,
      this.patientName,
      this.specialistName,
      this.doctorId});

  factory Appointments.fromFirestore(DocumentSnapshot doc) {
    return Appointments(
        bookdate: doc['bookdate'],
        doctorname: doc['doctorname'],
        time: doc['time'],
        patientID: doc['patientid'],
        patientName: doc['patientname'],
        specialistName: doc['specialistname'],
        doctorId: doc['doctorid']);
  }
}
