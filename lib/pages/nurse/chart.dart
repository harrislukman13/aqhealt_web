import 'package:aqhealth_web/controllers/database_controller.dart';
import 'package:aqhealth_web/models/appointment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Charts extends StatefulWidget {
  const Charts({super.key});

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  late TooltipBehavior _tooltipBehavior;
  double jancount = 0;
  double febcount = 0;
  double marchcount = 0;
  double aprilcount = 0;
  double maycount = 0;
  double junecount = 0;
  double julycount = 0;
  double augcount = 0;
  double sepcount = 0;
  double octcount = 0;
  double novcount = 0;
  double deccount = 0;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Appointments>>.value(
        initialData: [],
        value: DatabaseController.withoutUID().streamAppointment(),
        catchError: (context, error) => [],
        builder: (context, child) {
          List<Appointments> appointments =
              Provider.of<List<Appointments>>(context);
          List<ChartData> chartData = <ChartData>[];

          for (var e in appointments) {
            if (e.bookdate!.substring(5, 7).toString() == '01') {
              jancount++;
              chartData.add(ChartData(
                  x: DateTime.parse(e.bookdate!.replaceAll("-", "") +
                      'T' +
                      e.time!.toString() +
                      "00"),
                  y: jancount));
              //chartData.add(ChartData(x: "January", y: jancount++));
            } else if (e.bookdate!.substring(5, 7).toString() == '02') {
              febcount++;
              chartData.add(ChartData(
                  x: DateTime.parse(e.bookdate!.replaceAll("-", "") +
                      'T' +
                      e.time!.toString() +
                      "00"),
                  y: febcount));
              //chartData.add(ChartData(x: "February", y: febcount++));
            } else if (e.bookdate!.substring(5, 7).toString() == '03') {
              marchcount++;
              chartData.add(ChartData(
                  x: DateTime.parse(e.bookdate!.replaceAll("-", "") +
                      'T' +
                      e.time!.toString() +
                      "00"),
                  y: marchcount));
              //chartData.add(ChartData(x: "March", y: marchcount++));
            } else if (e.bookdate!.substring(5, 7).toString() == '04') {
              aprilcount++;
              chartData.add(ChartData(
                  x: DateTime.parse(e.bookdate!.replaceAll("-", "") +
                      'T' +
                      e.time!.toString() +
                      "00"),
                  y: aprilcount));
              //chartData.add(ChartData(x: "April", y: aprilcount++));
            } else if (e.bookdate!.substring(5, 7).toString() == '05') {
              maycount++;
              chartData.add(ChartData(
                  x: DateTime.parse(e.bookdate!.replaceAll("-", "") +
                      'T' +
                      e.time!.toString() +
                      "00"),
                  y: maycount));
              //chartData.add(ChartData(x: "May", y: maycount++));
            } else if (e.bookdate!.substring(5, 7).toString() == '06') {
              junecount++;
              chartData.add(ChartData(
                  x: DateTime.parse(e.bookdate!.replaceAll("-", "") +
                      'T' +
                      e.time!.toString() +
                      "00"),
                  y: junecount));
              //chartData.add(ChartData(x: "June", y: junecount++));
            } else if (e.bookdate!.substring(5, 7).toString() == '07') {
              julycount++;
              chartData.add(ChartData(
                  x: DateTime.parse(e.bookdate!.replaceAll("-", "") +
                      'T' +
                      e.time!.toString() +
                      "00"),
                  y: julycount));
              //chartData.add(ChartData(x: "July", y: julycount++));
            } else if (e.bookdate!.substring(5, 7).toString() == '08') {
              augcount++;
              chartData.add(ChartData(
                  x: DateTime.parse(e.bookdate!.replaceAll("-", "") +
                      'T' +
                      e.time!.toString() +
                      "00"),
                  y: augcount));
              //chartData.add(ChartData(x: "August", y: augcount++));
            } else if (e.bookdate!.substring(5, 7).toString() == '09') {
              sepcount++;
              chartData.add(ChartData(
                  x: DateTime.parse(e.bookdate!.replaceAll("-", "") +
                      'T' +
                      e.time!.toString() +
                      "00"),
                  y: sepcount));
              //chartData.add(ChartData(x: "September", y: sepcount++));
            } else if (e.bookdate!.substring(5, 7).toString() == '10') {
              octcount++;
              chartData.add(ChartData(
                  x: DateTime.parse(e.bookdate!.replaceAll("-", "") +
                      'T' +
                      e.time!.toString() +
                      "00"),
                  y: octcount));
              //chartData.add(ChartData(x: "October", y: octcount++));
            } else if (e.bookdate!.substring(5, 7).toString() == '11') {
              novcount++;
              chartData.add(ChartData(
                  x: DateTime.parse(e.bookdate!.replaceAll("-", "") +
                      'T' +
                      e.time!.toString() +
                      "00"),
                  y: novcount));
              //chartData.add(ChartData(x: "November", y: novcount++));
            } else if (e.bookdate!.substring(5, 7).toString() == '12') {
              deccount++;
              chartData.add(ChartData(
                  x: DateTime.parse(e.bookdate!.replaceAll("-", "") +
                      'T' +
                      e.time!.toString() +
                      "00"),
                  y: deccount));
              //chartData.add(ChartData(x: "December", y: deccount++));
            }
          }
          return Scaffold(
            body: ListView(
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  padding: EdgeInsets.all(4.h),
                  child: Card(
                    elevation: 3,
                    child: SfCartesianChart(
                      title: ChartTitle(text: "Appointment Statistics "),
                      legend: Legend(isVisible: true),
                      primaryXAxis: DateTimeAxis(),
                      series: <LineSeries<ChartData, dynamic>>[
                        LineSeries<ChartData, dynamic>(
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y)
                      ],
                      tooltipBehavior: _tooltipBehavior,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}

class ChartData {
  ChartData({required this.x, required this.y});
  final DateTime x;
  final double y;
  ChartData.fromMap(Map<String, dynamic> dataMap)
      : x = dataMap['x'],
        y = dataMap['y'];
}
