import 'dart:developer';
import 'dart:html';

import 'package:aqhealth_web/controllers/database_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:aqhealth_web/models/appointment.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Meeting> collection = [];
  MeetingDataSource? events;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Appointments>>.value(
        initialData: [],
        value: DatabaseController.withoutUID().streamAppointment(),
        catchError: (context, error) => [],
        builder: (context, child) {
          List<Appointments> appointment =
              Provider.of<List<Appointments>>(context);
          log(appointment.length.toString());

          if (appointment != null) {
            for (var e in appointment) {
              TimeOfDay rtime = TimeOfDay(hour: e.time!, minute: 0);
              DateTime startTime = DateTime.parse(
                  e.bookdate!.replaceAll("-", "") +
                      'T' +
                      e.time!.toString() +
                      "00");
              DateTime endTime = startTime.add(const Duration(hours: 1));
              collection.add(Meeting(e.doctorname!, startTime, endTime,
                  const Color(0xFF0F8644), false));

              events = MeetingDataSource(collection);
            }
          }

          return Scaffold(
            body: ListView(children: [
              SizedBox(
                height: 3.h,
              ),
              Padding(
                padding: EdgeInsets.all(2.h),
                child: SizedBox(
                  height: 70.h,
                  child: Container(
                    padding: EdgeInsets.all(2.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: SfCalendar(
                      view: CalendarView.month,
                      dataSource: events,
                      monthViewSettings: const MonthViewSettings(
                          showAgenda: true,
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.appointment),
                    ),
                  ),
                ),
              ),
            ]),
          );
        });
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
