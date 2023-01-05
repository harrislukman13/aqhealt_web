import 'dart:collection';

import 'package:aqhealth_web/controllers/auth_controller.dart';
import 'package:aqhealth_web/pages/nurse/dashboard.dart';
import 'package:aqhealth_web/pages/nurse/list_doctor.dart';
import 'package:aqhealth_web/widgets/responsive.dart';
import 'package:aqhealth_web/pages/nurse/queue.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

enum Menu {
  dashboard,
  listdoctor,
  queue,
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
      } else {
        selectedpage = page;
        _pageController.jumpToPage(2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(context),
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
                  ListDoctor(),
                  ManageQueue(),
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

AppBar NavBar(BuildContext context) {
  return AppBar(
    elevation: 3,
    backgroundColor: Colors.white,
    actions: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welcome',
            style: TextStyle(color: Colors.blue, fontSize: 3.sp),
          ),
          Text(
            "name",
            style: TextStyle(
                color: Colors.black,
                fontSize: 3.sp,
                fontWeight: FontWeight.bold),
          ),
        ],
      )
    ],
  );
}
