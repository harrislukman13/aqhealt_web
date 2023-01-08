import 'package:aqhealth_web/controllers/database_controller.dart';
import 'package:aqhealth_web/models/appointment.dart';
import 'package:aqhealth_web/pages/nurse/newappointment.dart';
import 'package:aqhealth_web/pages/nurse/oldappointment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:aqhealth_web/constants/color.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

class ManageQueue extends StatefulWidget {
  const ManageQueue({super.key});

  @override
  State<ManageQueue> createState() => _ManageQueueState();
}

enum Menu {
  newappointment,
  oldappointment,
}

class _ManageQueueState extends State<ManageQueue> {
  Menu selectedpage = Menu.newappointment;

  final PageController _pageController = PageController();

  bool _ispress = false;

  changePage(Menu page, Map<String, dynamic> data) {
    setState(() {
      if (page == Menu.newappointment) {
        selectedpage = page;
        _pageController.jumpToPage(0);
      } else if (page == Menu.oldappointment) {
        selectedpage = page;
        _pageController.jumpToPage(1);
      }
    });
  }

  final _qrScanner = QrBarCodeScannerDialog();
  String? id = '';
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Appointments>>.value(
        value: DatabaseController.withoutUID().streamAppointment(),
        initialData: [],
        catchError: (context, error) => [],
        builder: (context, snapshot) {
          List<Appointments> appointment =
              Provider.of<List<Appointments>>(context);
          return ListView(
            children: [
              SizedBox(
                height: 7.h,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(66.w, 0, 5.h, 0),
                child: SizedBox(
                  height: 4.h,
                  width: 10.h,
                  child: ElevatedButton(
                      onPressed: () {
                        _qrScanner.getScannedQrBarCode(
                            context: context,
                            onCode: (id) {
                              setState(() {
                                this.id = id;
                                print(id);
                              });
                            });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(primary),
                      ),
                      child: Text(
                        "Scan Patient Qr",
                        style: TextStyle(color: Colors.white, fontSize: 4.sp),
                      )),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Padding(
                padding: EdgeInsets.all(3.h),
                child: Container(
                  padding: EdgeInsets.all(1.h),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Patient Appointment",
                        style: TextStyle(
                            fontSize: 3.sp, fontWeight: FontWeight.bold),
                      ),
                      Container(
                          padding: EdgeInsets.all(5.h),
                          child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      height: 50.0,
                                      width: 20.w,
                                      color: Colors.transparent,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: _ispress
                                                ? Colors.white
                                                : primary,
                                            borderRadius:
                                                BorderRadius.horizontal(
                                                    left: Radius.circular(20)),
                                          ),
                                          child: Center(
                                              child: Text(
                                            "Appointment",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: _ispress
                                                    ? Colors.grey
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ))),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedpage = Menu.newappointment;
                                        _pageController.jumpToPage(0);
                                        _ispress = !_ispress;
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      height: 50.0,
                                      width: 20.w,
                                      color: Colors.transparent,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: _ispress
                                                  ? primary
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                      right:
                                                          Radius.circular(20))),
                                          child: Center(
                                            child: Text(
                                              "History",
                                              style: TextStyle(
                                                  color: _ispress
                                                      ? Colors.white
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedpage = Menu.oldappointment;
                                        _pageController.jumpToPage(1);
                                        _ispress = !_ispress;
                                      });
                                    },
                                  ),
                                ],
                              ))),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 75.h,
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            NewAppointment(appointment: appointment,),
                            OldAppointment(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

 
}
