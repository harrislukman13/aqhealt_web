import 'package:aqhealth_web/pages/landingpage.dart';
import 'package:aqhealth_web/pages/nurse/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.blue[50],
          textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.black),
          primarySwatch: Colors.blue,
        ),
        home: const Home(),
      );
    });
  }
}
