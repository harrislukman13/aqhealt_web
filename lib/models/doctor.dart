import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  String? id;
  String? doctorName;
  String? description;
  String? specialistname;
  String? specialistId;
  int? startTime;
  int? endTime;
  String? url;

  Doctor(
      { this.id,
       this.doctorName,
       this.description,
       this.specialistname,
       this.specialistId,
       this.startTime,
       this.endTime,
       this.url
      });

  factory Doctor.fromFireStore(DocumentSnapshot doc) {
    return Doctor(
        id: doc['id'],
        doctorName: doc['doctorname'],
        specialistname: doc['specialistname'],
        specialistId: doc['specialistid'],
        description: doc['description'],
        startTime: doc['starttime'],
        endTime: doc['endtime'],
        url: doc['url']);
  }

  static fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doctor) {}
}
