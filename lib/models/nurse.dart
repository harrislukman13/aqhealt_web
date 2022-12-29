
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;

  UserModel({required this.uid});
}

class Nurse {
  final String name;
  final String role;

  Nurse({required this.name, required this.role});

  factory Nurse.fromFireStore(DocumentSnapshot doc) {
    return Nurse(name: doc['name'], role: doc['role']);
  }
}
