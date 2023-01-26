import 'dart:developer';
import 'dart:js_util';

import 'package:aqhealth_web/models/appointment.dart';
import 'package:aqhealth_web/models/doctor.dart';
import 'package:aqhealth_web/models/notification.dart';
import 'package:aqhealth_web/models/queue.dart';
import 'package:aqhealth_web/models/specialist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DatabaseController {
  final String uid;
  DatabaseController({required this.uid});
  DatabaseController.withoutUID() : uid = "";

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final FirebaseDatabase _urldatabase = FirebaseDatabase.instance;

  Stream<List<Specialist>> streamSpecialist() {
    return _db.collection('Specialist').snapshots().map((list) => list.docs
        .map((specialist) => Specialist.fromFireStore(specialist))
        .toList());
  }

  Stream<List<Appointments>> streamAppointment() {
    return _db.collection('Appointment').snapshots().map((list) => list.docs
        .map((appointment) => Appointments.fromFirestore(appointment))
        .toList());
  }

  Future<List<Appointments>> getLatestApointment() async {
    QuerySnapshot<Map<String, dynamic>> data = await _db
        .collection('Appointment')
        .where('status', isEqualTo: 'success')
        .get();
    List<Appointments> appointments =
        data.docs.map((doc) => Appointments.fromFirestore(doc)).toList();
    return appointments;
  }

  Future<List<Appointments>> getHistoryApointment() async {
    QuerySnapshot<Map<String, dynamic>> data = await _db
        .collection('Appointment')
        .where('status', isEqualTo: 'completed')
        .get();
    List<Appointments> appointments =
        data.docs.map((doc) => Appointments.fromFirestore(doc)).toList();
    return appointments;
  }

  Stream<List<Doctor>> streamDoctor() {
    return _db.collection('Doctor').snapshots().map((list) =>
        list.docs.map((doctor) => Doctor.fromFireStore(doctor)).toList());
  }

  Future<bool> createDoctor(
    Doctor a,
  ) async {
    try {
      await _db.collection('Doctor').doc(a.id).set({
        'id': a.id,
        'doctorname': a.doctorName,
        'description': a.description,
        'specialistname': a.specialistname,
        'specialistid': a.specialistId,
        'starttime': a.startTime,
        'endtime': a.endTime,
        'url': a.url
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateDoctor(Doctor a) async {
    await _db.collection('Doctor').doc(a.id).update({
      'id': a.id,
      'doctorname': a.doctorName,
      'description': a.description,
      'specialistname': a.specialistname,
      'specialistid': a.specialistId,
      'starttime': a.startTime,
      'endtime': a.endTime,
      'url': a.url
    });
  }

  Future<void> updateAppointment(Appointments a) async {
    await _db.collection('Appointment').doc(a.appointmentId).update({
      'appointmentid': a.appointmentId,
      'bookdate': a.bookdate,
      'doctorname': a.doctorname,
      'time': a.time,
      'patientid': a.patientID,
      'patientname': a.patientName,
      'specialistname': a.specialistName,
      'doctorid': a.doctorId,
      'status': a.status,
    });
  }

  Future<void> deleteAppointment(String id) async {
    await _db.collection('Appointment').doc(id).delete();
  }

  Future<void> deleteDoctor(String id) async {
    await _db.collection('Doctor').doc(id).delete();
  }

  Future<void> addTask(Queues task) async {
    try {
      _urldatabase.databaseURL =
          "https://aqhealth-d8be5-default-rtdb.asia-southeast1.firebasedatabase.app";
      DatabaseReference ref = _urldatabase.ref('Task/${task.appointmentId}');
      await ref.set({
        "id": task.patientid.toString(),
        'name': task.patientname,
        "appointmentid": task.appointmentId,
        "priority": task.priority,
        "timestamp": task.timeStamp,
        "delay": task.delay,
        "room": task.room,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> changeStatus(String id, String status) async {
    dynamic data;
    try {
      data = _db.collection("Appointment").doc(id).update({'status': status});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> createNotification(Notifications a) async {
    try {
      await _db.collection("Notification").doc().set({
        'id': a.patientid,
        'notification': a.notifyText,
        'datetime': a.dateTime
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
