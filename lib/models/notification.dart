import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  String? patientid;
  String? notifyText;
  DateTime? dateTime;

  Notifications({this.patientid, this.notifyText, this.dateTime});

  factory Notifications.fromFireStore(DocumentSnapshot doc) {
    return Notifications(
        patientid: doc['id'],
        notifyText: doc['notification'],
        dateTime: doc['datetime']);
  }
}
