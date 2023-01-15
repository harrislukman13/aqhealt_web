import 'dart:async';
import 'dart:developer';

import 'package:aqhealth_web/controllers/database_controller.dart';
import 'package:aqhealth_web/models/appointment.dart';
import 'package:aqhealth_web/models/nurse.dart';
import 'package:aqhealth_web/models/queue.dart';
import 'package:aqhealth_web/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:queue/queue.dart';
import 'package:collection/collection.dart';
import 'package:sizer/sizer.dart';

class NewAppointment extends StatefulWidget {
  const NewAppointment(
      {super.key, required this.appointment, required this.uid});
  final UserModel uid;
  final List<Appointments> appointment;
  @override
  State<NewAppointment> createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {
  final priorityQueue =
      PriorityQueue<Queues>((a, b) => a.priority! - b.priority!);
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseController db =
        DatabaseController(uid: widget.uid.toString());
    return Container(
      child: _createDataTable(widget.appointment, db),
    );
  }

  DataTable _createDataTable(
      List<Appointments> appointments, DatabaseController db) {
    return DataTable(
        columns: _createColumns(), rows: _createRows(appointments, db));
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Patient Name')),
      DataColumn(label: Text('Specialist Name')),
      DataColumn(label: Text('Doctor Name')),
      DataColumn(label: Text('Book Date')),
      DataColumn(label: Text('Book Time')),
      DataColumn(label: Text('Queue')),
      DataColumn(label: Text('Setting')),
    ];
  }

  List<DataRow> _createRows(
      List<Appointments> appointments, DatabaseController db) {
    return appointments
        .map((appointment) => DataRow(cells: [
              DataCell(Text(appointment.patientName!)),
              DataCell(Text(appointment.specialistName!)),
              DataCell(Text(appointment.doctorname!)),
              DataCell(Text(appointment.bookdate!)),
              DataCell(Text(appointment.time.toString() + ':00')),
              DataCell(IconButton(
                onPressed: () {
                  final FocusNode roomFocus = FocusNode();
                  final FocusNode priorityFocus = FocusNode();
                  final FocusNode delayFocus = FocusNode();
                  final FocusNode idFocus = FocusNode();
                  final TextEditingController idController =
                      TextEditingController(text: appointment.patientID);
                  final TextEditingController roomController =
                      TextEditingController();

                  final TextEditingController priorityController =
                      TextEditingController();
                  final TextEditingController delayController =
                      TextEditingController();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            "Create Queue",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          actions: [
                            Form(
                                key: _formKey,
                                child: const SizedBox(height: 20)),
                            CustomTextFormField(
                              hintText: 'PatientID',
                              focusNode: idFocus,
                              controller: idController,
                              validator: (value) => value!.length <= 10
                                  ? 'less than 30 character'
                                  : null,
                            ),
                            SizedBox(height: 3.h),
                            CustomTextFormField(
                              hintText: 'Room',
                              focusNode: roomFocus,
                              controller: roomController,
                              validator: (value) => value!.length <= 10
                                  ? 'less than 30 character'
                                  : null,
                            ),
                            SizedBox(height: 3.h),
                            CustomTextFormField(
                              hintText: 'Priority',
                              focusNode: priorityFocus,
                              controller: priorityController,
                              validator: (value) => value!.length <= 30
                                  ? 'less than 30 character'
                                  : null,
                            ),
                            SizedBox(height: 3.h),
                            CustomTextFormField(
                              hintText: 'Delay',
                              focusNode: delayFocus,
                              controller: delayController,
                              validator: (value) => value!.length <= 10
                                  ? 'must in 24 hours'
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
                                  await db.addTask(Queues(
                                      appointmentId: idController.text,
                                      timeStamp: DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toInt(),
                                      priority:
                                          int.parse(priorityController.text),
                                      delay: int.parse(delayController.text),
                                      id: DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toString()));
                                }

                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Update',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      });
                },
                icon: Icon(Icons.queue),
              )),
              DataCell(Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.delete_forever)),
                ],
              ))
            ]))
        .toList();
  }
}
