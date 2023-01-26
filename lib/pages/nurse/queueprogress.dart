import 'dart:convert';
import 'dart:developer';

import 'package:aqhealth_web/controllers/database_controller.dart';
import 'package:aqhealth_web/models/queue.dart';
import 'package:aqhealth_web/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/date_symbols.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class QueueManage extends StatefulWidget {
  const QueueManage({super.key});

  @override
  State<QueueManage> createState() => _QueueManageState();
}

class _QueueManageState extends State<QueueManage> {
  final FirebaseDatabase _urldatabase = FirebaseDatabase.instance;
  List<Queues> queues = [];

  @override
  void initState() {
    super.initState();
  }

  Stream<DatabaseEvent> listen() {
    _urldatabase.databaseURL =
        "https://aqhealth-d8be5-default-rtdb.asia-southeast1.firebasedatabase.app";
    DatabaseReference ref = _urldatabase.ref('Task');
    return ref.onValue;
  }

  Future<void> deleteQueue(String? appointmentid) async {
    _urldatabase.databaseURL =
        "https://aqhealth-d8be5-default-rtdb.asia-southeast1.firebasedatabase.app";
    DatabaseReference ref = _urldatabase.ref('Task/${appointmentid}');
    await ref.remove();
  }

  Future<void> updateQueue(
      String? appointmentid,
      String? patientname,
      String? patientid,
      int? priority,
      int? timestamp,
      int? delay,
      int? room) async {
    _urldatabase.databaseURL =
        "https://aqhealth-d8be5-default-rtdb.asia-southeast1.firebasedatabase.app";
    DatabaseReference ref = _urldatabase.ref('Task/${appointmentid}');

    Map<String, dynamic> data = <String, dynamic>{
      'id': patientid,
      'patient': patientname,
      'appointmentid': appointmentid,
      'priority': priority,
      'timestamp': timestamp,
      'delay': delay,
      'room': room,
    };
    await ref.update(data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamProvider<DatabaseEvent?>.value(
        value: listen(),
        initialData: null,
        builder: (context, child) {
          return Consumer<DatabaseEvent?>(
            builder: (context, event, child) {
              if (event != null) {
                if (event.snapshot.exists) {
                  queues = [];
                  Map<String, dynamic> data =
                      (event.snapshot.value as Map<String, dynamic>);

                  data.forEach(
                    (key, value) {
                      queues.add(Queues.fromJson(value));
                    },
                  );

                  queues.sort(
                    (a, b) {
                      if (a.priority! < b.priority!) {
                        return 1;
                      } else if (a.timeStamp! > b.timeStamp!) {
                        return 1;
                      }
                      return 0;
                    },
                  );
                }
              } else if (event == null) {
                return Container();
              }
              if (queues == null) {
                Container();
              }
              return _createDataTable(queues);
            },
          );
        },
      ),
    );
  }

  DataTable _createDataTable(List<Queues> sorts) {
    return DataTable(
      columns: _createColumns(),
      rows: _createRows(sorts).toList(),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Patient Name')),
      DataColumn(label: Text('Priority')),
      DataColumn(label: Text('timestamp')),
      DataColumn(label: Text('Delay')),
      DataColumn(label: Text('Room')),
      DataColumn(label: Text('Edit')),
    ];
  }

  Iterable<DataRow> _createRows(List<Queues> sorts) {
    return sorts.map((sort) => DataRow(cells: [
          DataCell(Text(sort.patientname!)),
          DataCell(Text(sort.priority!.toString())),
          DataCell(Text(sort.timeStamp!.toString())),
          DataCell(Text(sort.delay!.toString())),
          DataCell(Text(sort.room.toString())),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          final GlobalKey<FormState> _formKey = GlobalKey();
                          final FocusNode appointmentid = FocusNode();
                          final FocusNode priority = FocusNode();
                          final FocusNode delay = FocusNode();
                          final FocusNode room = FocusNode();
                          final TextEditingController appointmentController =
                              TextEditingController(
                                  text: sort.appointmentId.toString());
                          final TextEditingController priorityController =
                              TextEditingController(
                                  text: sort.priority.toString());
                          final TextEditingController delayController =
                              TextEditingController(
                                  text: sort.delay.toString());
                          final TextEditingController roomController =
                              TextEditingController(text: sort.room.toString());

                          return StatefulBuilder(
                              builder: (stfContext, stfSetState) {
                            return AlertDialog(
                              title: const Text(
                                "Update Queue",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              actions: [
                                Form(
                                    key: _formKey,
                                    child: const SizedBox(height: 20)),
                                CustomTextFormField(
                                  hintText: 'AppointmentID',
                                  focusNode: appointmentid,
                                  controller: appointmentController,
                                  validator: (value) => value!.length <= 10
                                      ? 'less than 30 character'
                                      : null,
                                ),
                                SizedBox(height: 3.h),
                                CustomTextFormField(
                                  hintText: 'Priority',
                                  focusNode: priority,
                                  controller: priorityController,
                                  validator: (value) => value!.length <= 10
                                      ? 'less than 30 character'
                                      : null,
                                ),
                                SizedBox(height: 3.h),
                                CustomTextFormField(
                                  hintText: 'Delay Time',
                                  focusNode: delay,
                                  controller: delayController,
                                  validator: (value) => value!.length <= 30
                                      ? 'less than 30 character'
                                      : null,
                                ),
                                SizedBox(height: 3.h),
                                CustomTextFormField(
                                  hintText: 'Room Number',
                                  focusNode: room,
                                  controller: roomController,
                                  validator: (value) => value!.length <= 30
                                      ? 'less than 30 character'
                                      : null,
                                ),
                                SizedBox(height: 5.h),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await updateQueue(
                                          sort.appointmentId,
                                          sort.patientname,
                                          sort.patientid,
                                          int.parse(priorityController.text
                                              .toString()),
                                          sort.timeStamp,
                                          int.parse(delayController.text),
                                          int.parse(roomController.text));
                                    }

                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Update Appointment',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          });
                        });
                  },
                  icon: Icon(Icons.edit)),
              IconButton(
                  onPressed: () async {
                    await deleteQueue(sort.appointmentId);
                  },
                  icon: Icon(Icons.delete_forever))
            ],
          ))
        ]));
  }
}
