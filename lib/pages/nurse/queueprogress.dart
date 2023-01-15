import 'dart:convert';
import 'dart:developer';

import 'package:aqhealth_web/controllers/database_controller.dart';
import 'package:aqhealth_web/models/queue.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/date_symbols.dart';
import 'package:provider/provider.dart';

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
      DataColumn(label: Text('Appointment ID')),
      DataColumn(label: Text('Priority')),
      DataColumn(label: Text('timestamp')),
      DataColumn(label: Text('Delay')),
    ];
  }

  Iterable<DataRow> _createRows(List<Queues> sorts) {
    return sorts.map((sort) => DataRow(cells: [
          DataCell(Text(sort.appointmentId!)),
          DataCell(Text(sort.priority!.toString())),
          DataCell(Text(sort.timeStamp!.toString())),
          DataCell(Text(sort.delay!.toString())),
        ]));
  }
}
