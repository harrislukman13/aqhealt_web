import 'dart:async';
import 'dart:developer';

import 'package:aqhealth_web/constants/color.dart';
import 'package:aqhealth_web/controllers/database_controller.dart';
import 'package:aqhealth_web/models/appointment.dart';
import 'package:aqhealth_web/models/doctor.dart';
import 'package:aqhealth_web/models/notification.dart';
import 'package:aqhealth_web/models/nurse.dart';
import 'package:aqhealth_web/models/queue.dart';
import 'package:aqhealth_web/models/specialist.dart';
import 'package:aqhealth_web/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue/queue.dart';
import 'package:collection/collection.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

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
  List<Appointments> latestAppointment = [];

  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  @override
  void initState() {
    super.initState();
    // setState(() {
    //   // getLatestAppointment();
    //   // log(latestAppointment.length.toString());
    // });
  }

  // getLatestAppointment() {
  //   for (int i = 0; i < widget.appointment.length; i++) {
  //     if (widget.appointment[i].status == "sucess") {
  //       latestAppointment.add(widget.appointment[i]);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final DatabaseController db =
        DatabaseController(uid: widget.uid.toString());
    return FutureBuilder(
        future: DatabaseController.withoutUID().getLatestApointment(),
        builder: (context, AsyncSnapshot<List<Appointments>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Appointments>? appointments = snapshot.data;
            return StreamProvider<List<Doctor>>.value(
                value: DatabaseController.withoutUID().streamDoctor(),
                initialData: [],
                catchError: (context, error) => [],
                builder: (context, child) {
                  List<Doctor> doctors = Provider.of<List<Doctor>>(context);
                  return StreamProvider<List<Specialist>>.value(
                      initialData: [],
                      value: DatabaseController.withoutUID().streamSpecialist(),
                      catchError: (context, error) => [],
                      builder: (context, child) {
                        List<Specialist> specialists =
                            Provider.of<List<Specialist>>(context);
                        return Container(
                          child: _createDataTable(
                              appointments, db, doctors, specialists),
                        );
                      });
                });
          } else {
            return Container();
          }
        });
  }

  DataTable _createDataTable(
      List<Appointments>? appointments,
      DatabaseController db,
      List<Doctor> doctors,
      List<Specialist> specialists) {
    return DataTable(
        columns: _createColumns(),
        rows: _createRows(appointments, db, doctors, specialists));
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Patient Name')),
      DataColumn(label: Text('Specialist Name')),
      DataColumn(label: Text('Doctor Name')),
      DataColumn(label: Text('Book Date')),
      DataColumn(label: Text('Book Time')),
      DataColumn(label: Text('Queue')),
      DataColumn(label: Text('Notify')),
      DataColumn(label: Text('Setting')),
    ];
  }

  List<DataRow> _createRows(
      List<Appointments>? appointments,
      DatabaseController db,
      List<Doctor> doctors,
      List<Specialist> specialists) {
    return appointments!
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
                  final FocusNode appidFocus = FocusNode();
                  final TextEditingController idController =
                      TextEditingController(text: appointment.patientID);
                  final TextEditingController appidController =
                      TextEditingController(text: appointment.appointmentId);
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
                              hintText: 'Appointment',
                              focusNode: appidFocus,
                              controller: appidController,
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
                                      appointmentId: appidController.text,
                                      patientname: appointment.patientName,
                                      timeStamp: DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toInt(),
                                      priority:
                                          int.parse(priorityController.text),
                                      delay: int.parse(delayController.text),
                                      patientid: idController.text,
                                      room: int.parse(roomController.text)));

                                  await db.changeStatus(
                                      appidController.text, "completed");
                                }

                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Add',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      });
                },
                icon: Icon(Icons.queue),
              )),
              DataCell(IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          final FocusNode notyFocus = FocusNode();
                          final TextEditingController notyController =
                              TextEditingController(
                                  text:
                                      "Please check your updated Queue date and Time");
                          return StatefulBuilder(builder: ((context, setState) {
                            return AlertDialog(
                              title: const Text(
                                "Notify Patient",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              actions: [
                                Form(
                                  key: _formKey,
                                  child: SizedBox(
                                    height: 20,
                                  ),
                                ),
                                CustomTextFormField(
                                  hintText: 'Notifications',
                                  focusNode: notyFocus,
                                  controller: notyController,
                                  validator: (value) => value!.length <= 10
                                      ? 'less than 30 character'
                                      : null,
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
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
                                      await db.createNotification(Notifications(
                                          patientid: appointment.patientID,
                                          notifyText: notyController.text,
                                          dateTime: DateTime.now()));
                                    }

                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Send Notification',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          }));
                        }));
                  },
                  icon: Icon(CupertinoIcons.bell_fill))),
              DataCell(Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              String? doctorid = appointment.doctorId;
                              String? doctorname = appointment.doctorname;
                              String? specialistname =
                                  appointment.specialistName;

                              String? _selectedDate;
                              DateTime? selectedDate;
                              DateTime focusDate = DateTime.parse(
                                  appointment.bookdate.toString());
                              print(focusDate.toString());

                              final FocusNode timeFocus = FocusNode();
                              final FocusNode idFocus = FocusNode();
                              final FocusNode appidFocus = FocusNode();
                              final TextEditingController idController =
                                  TextEditingController(
                                      text: appointment.patientID);
                              final TextEditingController appidController =
                                  TextEditingController(
                                      text: appointment.appointmentId);
                              final TextEditingController timeController =
                                  TextEditingController(
                                      text: appointment.time.toString());

                              return StatefulBuilder(
                                  builder: (stfContext, stfSetState) {
                                return AlertDialog(
                                  title: const Text(
                                    "Update Appointment",
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
                                      hintText: 'Appointment',
                                      focusNode: appidFocus,
                                      controller: appidController,
                                      validator: (value) => value!.length <= 10
                                          ? 'less than 30 character'
                                          : null,
                                    ),
                                    SizedBox(height: 3.h),
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: primary, width: 3),
                                          borderRadius:
                                              BorderRadius.circular(23)),
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: DropdownButton(
                                          hint: doctorname == null
                                              ? Text("Doctor name")
                                              : Text(doctorname!),
                                          isExpanded: true,
                                          items: doctors.map((e) {
                                            return DropdownMenuItem<String>(
                                              value: e.id! + e.doctorName!,
                                              child: Text(e.doctorName!),
                                            );
                                          }).toList(),
                                          onChanged: (e) {
                                            stfSetState(() {
                                              doctorid = e!
                                                  .substring(0, 16)
                                                  .toString();
                                              doctorname =
                                                  e.substring(16).toString();
                                              print(doctorid);

                                              //doctorid = e.toString();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: primary, width: 3),
                                          borderRadius:
                                              BorderRadius.circular(23)),
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: DropdownButton(
                                            hint: specialistname == null
                                                ? Text("Specialist name")
                                                : Text(specialistname!),
                                            isExpanded: true,
                                            items: specialists.map((e) {
                                              return DropdownMenuItem<String>(
                                                value: e.id + e.specialistname,
                                                child: Text(e.specialistname),
                                              );
                                            }).toList(),
                                            onChanged: (e) {
                                              stfSetState(() {
                                                specialistname =
                                                    e!.substring(20).toString();
                                                print(specialistname);
                                              });
                                            }),
                                      ),
                                    ),
                                    Center(
                                      child: SizedBox(
                                        height: 35.h,
                                        width: 50.w,
                                        child: TableCalendar(
                                          focusedDay: focusDate,
                                          firstDay: DateTime.now(),
                                          lastDay: DateTime(
                                            DateTime.now().year + 1,
                                            DateTime.now().month,
                                            DateTime.now().day,
                                          ),
                                          selectedDayPredicate: (day) {
                                            return isSameDay(selectedDate, day);
                                          },
                                          onDaySelected:
                                              (selectedDay, focusedDay) {
                                            stfSetState(() {
                                              selectedDate = selectedDay;
                                              _selectedDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(selectedDate!);
                                              focusDate = focusedDay;
                                            });
                                          },
                                          onFormatChanged: (format) {
                                            if (_calendarFormat != format) {
                                              stfSetState(() {
                                                _calendarFormat = format;
                                              });
                                            }
                                          },
                                          onPageChanged: (focusedDay) {
                                            focusDate = focusedDay;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    CustomTextFormField(
                                      hintText: 'Time',
                                      focusNode: timeFocus,
                                      controller: timeController,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          await db.updateAppointment(
                                              Appointments(
                                                  appointmentId:
                                                      appointment.appointmentId,
                                                  patientID:
                                                      appointment.patientID,
                                                  bookdate: _selectedDate,
                                                  time: int.parse(
                                                      timeController.text),
                                                  doctorId: doctorid,
                                                  doctorname: doctorname,
                                                  specialistName:
                                                      specialistname,
                                                  status: "success"));
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
                        //Navigator.pop(context);
                      },
                      icon: Icon(Icons.edit)),
                  IconButton(
                      onPressed: () async {
                        await db.deleteAppointment(appointment.appointmentId!);
                      },
                      icon: Icon(Icons.delete_forever)),
                ],
              ))
            ]))
        .toList();
  }
}
