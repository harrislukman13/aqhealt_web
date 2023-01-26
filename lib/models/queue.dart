import 'package:flutter/cupertino.dart';

class Queues {
  String? patientid;
  String? patientname;
  int? priority;
  String? appointmentId;
  int? timeStamp;
  int? delay;
  int? room;

  Queues(
      {this.patientid,
      this.patientname,
      this.appointmentId,
      this.timeStamp,
      this.priority,
      this.delay,
      this.room});

  factory Queues.fromJson(Map<String, dynamic> map) => Queues(
      patientid: map['id'] ?? '',
      patientname: map['name'] ?? '',
      appointmentId: map['appointmentid'] ?? '',
      priority: map['priority'] ?? 0,
      timeStamp: map['timestamp'] ?? 0,
      delay: map['delay'] ?? 0,
      room: map['room'] ?? 0);

  Map<String, dynamic> toJson() {
    return {
      'id': patientid,
      'name': patientname,
      'appointmentid': appointmentId,
      'priority': priority,
      'timestamp': timeStamp,
      'delay': delay,
      'room': room,
    };
  }
}
