import 'package:aqhealth_web/models/nurse.dart';
import 'package:aqhealth_web/pages/landingpage.dart';
import 'package:aqhealth_web/pages/nurse/home.dart';
import 'package:aqhealth_web/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('User');

    if (user == null) {
      return const LandingPage();
    } else {
      return FutureBuilder(
          future: users.doc((FirebaseAuth.instance.currentUser!).uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map data = (snapshot.data!.data() ?? {}) as Map;
              if (data['role'] == 'Nurse' || data['role'] == 'nurse') {
                return Home(
                  data: data,
                );
              }
            }
            return Loading();
          });
    }
  }
}
