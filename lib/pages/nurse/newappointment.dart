import 'package:aqhealth_web/models/appointment.dart';
import 'package:flutter/material.dart';

class NewAppointment extends StatefulWidget {
  const NewAppointment({super.key, required this.appointment});

  final List<Appointments> appointment;
  @override
  State<NewAppointment> createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _createDataTable(widget.appointment),
    );
  }

  DataTable _createDataTable(List<Appointments> appointments) {
    return DataTable(
        columns: _createColumns(), rows: _createRows(appointments));
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Patient Name')),
      DataColumn(label: Text('Specialist Name')),
      DataColumn(label: Text('Doctor Name')),
      DataColumn(label: Text('Book Date')),
      DataColumn(label: Text('Book Time')),
      DataColumn(label: Text('Queue')),
    ];
  }

  List<DataRow> _createRows(List<Appointments> appointments) {
    return appointments
        .map((appointment) => DataRow(cells: [
              DataCell(Text(appointment.patientName!)),
              DataCell(Text(appointment.specialistName!)),
              DataCell(Text(appointment.doctorname!)),
              DataCell(Text(appointment.bookdate!)),
              DataCell(Text(appointment.time.toString() + ':00')),
              DataCell(Text('')),
            ]))
        .toList();
  }
}
