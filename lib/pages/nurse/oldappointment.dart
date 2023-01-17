import 'package:aqhealth_web/controllers/database_controller.dart';
import 'package:aqhealth_web/models/appointment.dart';
import 'package:flutter/material.dart';

class OldAppointment extends StatefulWidget {
  const OldAppointment({super.key});

  @override
  State<OldAppointment> createState() => _OldAppointmentState();
}

class _OldAppointmentState extends State<OldAppointment> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseController.withoutUID().getHistoryApointment(),
        builder: (context, AsyncSnapshot<List<Appointments>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Appointments>? appointments = snapshot.data;
            return Container(
              child: _createDataTable(appointments),
            );
          } else {
            return Container(
              child: _createmptyTable(),
            );
          }
        });
  }

  DataTable _createDataTable(List<Appointments>? appoinments) {
    return DataTable(
      columns: _createColumns(),
      rows: _createRows(appoinments),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Patient Name')),
      DataColumn(label: Text('Specialist Name')),
      DataColumn(label: Text('Doctor Name')),
      DataColumn(label: Text('Book Date')),
      DataColumn(label: Text('Book Time')),
    ];
  }

  List<DataRow> _createRows(List<Appointments>? appointments) {
    return appointments!
        .map((appointment) => DataRow(cells: [
              DataCell(Text(appointment.patientName!)),
              DataCell(Text(appointment.specialistName!)),
              DataCell(Text(appointment.doctorname!)),
              DataCell(Text(appointment.bookdate!)),
              DataCell(Text(appointment.time.toString() + ':00')),
            ]))
        .toList();
  }

  ////////////////////////////////////////////////////////////////

  DataTable _createmptyTable() {
    return DataTable(
      columns: _createmptyColumns(),
      rows: [],
    );
  }

  List<DataColumn> _createmptyColumns() {
    return [
      DataColumn(label: Text('Patient Name')),
      DataColumn(label: Text('Specialist Name')),
      DataColumn(label: Text('Doctor Name')),
      DataColumn(label: Text('Book Date')),
      DataColumn(label: Text('Book Time')),
    ];
  }
}
