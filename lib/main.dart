import 'package:aqhealth_web/controllers/auth_controller.dart';
import 'package:aqhealth_web/models/nurse.dart';
import 'package:aqhealth_web/pages/landingpage.dart';
import 'package:aqhealth_web/pages/nurse/Wrapper.dart';
import 'package:aqhealth_web/pages/nurse/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyAsAtF4R2b9slePAAlPNSkG1Xmd3I4j54Q",
    projectId: "aqhealth-d8be5",
    messagingSenderId: "636292154698",
    appId: "1:636292154698:web:43e7eed500a81832906db3",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return StreamProvider<UserModel?>.value(
          value: AuthController().user,
          initialData: null,
          child: MaterialApp(
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.blue[50],
              textTheme:
                  GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
                      .apply(bodyColor: Colors.black),
              primarySwatch: Colors.blue,
            ),
            home: Wrapper(),
          ));
    });
  }
}
