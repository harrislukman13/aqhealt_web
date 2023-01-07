import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:aqhealth_web/constants/color.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

class ManageQueue extends StatefulWidget {
  const ManageQueue({super.key});

  @override
  State<ManageQueue> createState() => _ManageQueueState();
}

class _ManageQueueState extends State<ManageQueue> {
  final _qrScanner = QrBarCodeScannerDialog();
  String? id = '';
  @override
  Widget build(BuildContext context) {
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
                  style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.bold),
                ),
                Container(
                    padding: EdgeInsets.all(5.h),
                    child: SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Patient Name')),
                            DataColumn(label: Text('Specialist Name')),
                            DataColumn(label: Text('Doctor Name')),
                            DataColumn(label: Text('Book Date')),
                            DataColumn(label: Text('Book Time')),
                            DataColumn(label: Text('Queue')),
                          ],
                          rows: [],
                        ))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
