import 'dart:collection';

import 'package:aqhealth_web/controllers/auth_controller.dart';
import 'package:aqhealth_web/controllers/database_controller.dart';
import 'package:aqhealth_web/models/nurse.dart';
import 'package:aqhealth_web/pages/nurse/chart.dart';
import 'package:aqhealth_web/pages/nurse/dashboard.dart';
import 'package:aqhealth_web/pages/nurse/list_doctor.dart';
import 'package:aqhealth_web/widgets/responsive.dart';
import 'package:aqhealth_web/pages/nurse/queue.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.data});

  final Map<dynamic, dynamic> data;

  @override
  State<Home> createState() => _HomeState();
}

enum Menu {
  dashboard,
  listdoctor,
  queue,
  chart,
}

class _HomeState extends State<Home> {
  Menu selectedpage = Menu.dashboard;
  AuthController _auth = AuthController();
  final PageController _pageController = PageController();

  changePage(Menu page, Map<String, dynamic> data) {
    setState(() {
      if (page == Menu.dashboard) {
        selectedpage = page;
        _pageController.jumpToPage(0);
      } else if (page == Menu.listdoctor) {
        selectedpage = page;
        _pageController.jumpToPage(1);
      } else if (page == Menu.queue) {
        selectedpage = page;
        _pageController.jumpToPage(2);
      } else {
        selectedpage = page;
        _pageController.jumpToPage(3);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final db = DatabaseController(uid: user!.uid);
    return Scaffold(
      appBar: NavBar(context, widget.data),
      drawer: SideMenu(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isLargeScreen(context)) Expanded(child: SideMenu()),
          Expanded(
              flex: 5,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Dashboard(),
                  ListDoctor(
                    db: db,
                  ),
                  ManageQueue(
                    uid: user,
                  ),
                  Charts(),
                ],
              ))
        ],
      ),
    );
  }

  Drawer SideMenu() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/hospital.png"),
          ),
          ListTile(
            title: Text(
              'Dashboard',
              style: TextStyle(color: Colors.blue),
            ),
            leading: Icon(CupertinoIcons.house),
            onTap: () {
              setState(() {
                selectedpage = Menu.dashboard;
                _pageController.jumpToPage(0);
              });
            },
          ),
          ListTile(
            title: Text(
              'List Doctor',
              style: TextStyle(color: Colors.blue),
            ),
            leading: Icon(CupertinoIcons.calendar),
            onTap: () {
              setState(() {
                selectedpage = Menu.listdoctor;
                _pageController.jumpToPage(1);
              });
            },
          ),
          ListTile(
            title: Text(
              'Manage Queue',
              style: TextStyle(color: Colors.blue),
            ),
            leading: Icon(CupertinoIcons.person),
            onTap: () {
              setState(() {
                selectedpage = Menu.queue;
                _pageController.jumpToPage(2);
              });
            },
          ),
          ListTile(
            title: Text(
              'Chart',
              style: TextStyle(color: Colors.blue),
            ),
            leading: Icon(CupertinoIcons.chart_bar),
            onTap: () {
              setState(() {
                selectedpage = Menu.queue;
                _pageController.jumpToPage(3);
              });
            },
          ),
          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.blue),
            ),
            leading: Icon(CupertinoIcons.power),
            onTap: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}

AppBar NavBar(BuildContext context, Map<dynamic, dynamic> data) {
  return AppBar(
    elevation: 3,
    backgroundColor: Colors.white,
    actions: [
      Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 4.h, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Nurse',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 2.sp,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 1.w,
            ),
            Text(
              'Welcome',
              style: TextStyle(color: Colors.blue, fontSize: 2.sp),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              data['name'],
              style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 3.sp,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      )
    ],
  );
}
