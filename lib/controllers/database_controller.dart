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
    String specialistID,
    String name,
    String specialistname,
    String description,
    int starttime,
    int endtime,
  ) async {
    try {
      await _db.collection('Doctor').doc().set({
        'doctorname': name,
        'description': description,
        'specialistid': specialistID,
        'specialistname': specialistname,
        'starttime': starttime,
        'endtime': endtime,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
