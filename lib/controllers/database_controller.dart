import 'dart:developer';

import 'package:aqhealth_web/models/appointment.dart';
import 'package:aqhealth_web/models/doctor.dart';
import 'package:aqhealth_web/models/specialist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseController {
  final String uid;
  DatabaseController({required this.uid});
  DatabaseController.withoutUID() : uid = "";

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

  Stream<List<Doctor>> streamDoctor() {
    return _db.collection('Doctor').snapshots().map((list) =>
        list.docs.map((doctor) => Doctor.fromFireStore(doctor)).toList());
  }

  Future<bool> createDoctor(
    Doctor a,
  ) async {
    try {
      final String id = DateTime.now().microsecondsSinceEpoch.toString();
      await _db.collection('Doctor').doc(id).set({
        'id': a.id,
        'doctorname': a.doctorName,
        'description': a.description,
        'specialistname': a.specialistname,
        'specialistid': a.specialistId,
        'starttime': a.startTime,
        'endtime': a.endTime,
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
    });
  }

  Future<void> deleteDoctor(String id) async {
    await _db.collection('Doctor').doc(id).delete();
  }
}
