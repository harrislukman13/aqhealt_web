import 'package:flutter/material.dart';

class OldAppointment extends StatefulWidget {
  const OldAppointment({super.key});

  @override
  State<OldAppointment> createState() => _OldAppointmentState();
}

class _OldAppointmentState extends State<OldAppointment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _createDataTable(),
    );
  }

  DataTable _createDataTable() {
    return DataTable(
      columns: _createColumns(),
      rows: [],
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

  //List<DataRow> _createRows() {}
}
