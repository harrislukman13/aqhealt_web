import 'dart:developer';

import 'package:aqhealth_web/constants/color.dart';
import 'package:aqhealth_web/controllers/database_controller.dart';
import 'package:aqhealth_web/models/doctor.dart';
import 'package:aqhealth_web/models/nurse.dart';
import 'package:aqhealth_web/models/specialist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_text_field.dart';

class ListDoctor extends StatefulWidget {
  const ListDoctor({super.key, required this.db});
  final DatabaseController db;
  @override
  State<ListDoctor> createState() => _ListDoctorState();
}

class _ListDoctorState extends State<ListDoctor> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode nameFocus = FocusNode();
  final FocusNode descFocus = FocusNode();
  final FocusNode startFocus = FocusNode();
  final FocusNode endFocus = FocusNode();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();

  String? _specialist;
  bool isLoading = false;
  String error = '';
  String? _specialistid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Specialist>>.value(
        value: DatabaseController.withoutUID().streamSpecialist(),
        initialData: [],
        catchError: (context, error) => [],
        builder: (context, snapshot) {
          List<Specialist> specialist = Provider.of<List<Specialist>>(context);
          return StreamProvider<List<Doctor>>.value(
              value: DatabaseController.withoutUID().streamDoctor(),
              initialData: [],
              catchError: (context, error) => [],
              builder: (context, snapshot) {
                List<Doctor> doctor = Provider.of<List<Doctor>>(context);
                log(doctor.length.toString());
                return ListView(
                  children: [
                    SizedBox(
                      height: 7.h,
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 4.h,
                            width: 20.w,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search",
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                suffixIcon: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Icon(CupertinoIcons.search),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 3.h,
                          ),
                          SizedBox(
                            height: 4.h,
                            width: 17.h,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(primary),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Add Doctor",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          actions: [
                                            Form(
                                                key: _formKey,
                                                child:
                                                    const SizedBox(height: 20)),
                                            CustomTextFormField(
                                              hintText: 'Name',
                                              focusNode: nameFocus,
                                              controller: nameController,
                                              validator: (value) =>
                                                  value!.length <= 10
                                                      ? 'less than 30 character'
                                                      : null,
                                            ),
                                            SizedBox(height: 3.h),
                                            SizedBox(
                                              height: 6.h,
                                              width: 100.w,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: primary, width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      2.w, 0, 0, 0),
                                                  child: DropdownButton(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .centerStart,
                                                    style: TextStyle(
                                                        color: primary),
                                                    hint: specialist != null
                                                        ? Text(
                                                            'Specialist',
                                                            style: TextStyle(
                                                                color: primary),
                                                          )
                                                        : Text(
                                                            _specialist!,
                                                            style: TextStyle(
                                                                color: primary),
                                                          ),
                                                    onChanged: (e) {
                                                      setState(
                                                        () {
                                                          _specialistid = e
                                                              ?.substring(0, 20)
                                                              .toString();
                                                          _specialist = e
                                                              ?.substring(20)
                                                              .toString();
                                                          print(_specialistid);
                                                        },
                                                      );
                                                    },
                                                    items: specialist.map((e) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: e.id +
                                                            e.specialistname,
                                                        child: Text(
                                                            e.specialistname),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 3.h),
                                            CustomTextFormField(
                                              hintText: 'Description',
                                              focusNode: descFocus,
                                              controller: descController,
                                              validator: (value) =>
                                                  value!.length <= 30
                                                      ? 'less than 30 character'
                                                      : null,
                                            ),
                                            SizedBox(height: 3.h),
                                            CustomTextFormField(
                                              hintText: 'Start Time',
                                              focusNode: startFocus,
                                              controller: startController,
                                              validator: (value) =>
                                                  value!.length <= 10
                                                      ? 'must in 24 hours'
                                                      : null,
                                            ),
                                            SizedBox(height: 3.h),
                                            CustomTextFormField(
                                              hintText: 'End Time',
                                              focusNode: endFocus,
                                              controller: endController,
                                              validator: (value) =>
                                                  value!.length <= 10
                                                      ? 'must in 24 hours'
                                                      : null,
                                            ),
                                            SizedBox(height: 5.h),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.indigo,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 15,
                                                  horizontal: 20,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              onPressed: () async {
                                                final String id = DateTime.now()
                                                    .microsecondsSinceEpoch
                                                    .toString();
                                                await widget.db.createDoctor(
                                                    Doctor(
                                                        id: id,
                                                        doctorName: nameController
                                                            .text,
                                                        description:
                                                            descController.text,
                                                        specialistname:
                                                            _specialist!,
                                                        specialistId:
                                                            _specialistid!,
                                                        startTime: int.parse(
                                                            startController
                                                                .text),
                                                        endTime:
                                                            int.parse(
                                                                endController
                                                                    .text)));
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Submit',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Text(
                                  "Add Doctor",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 4.sp),
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.h),
                      child: Container(
                        padding: EdgeInsets.all(1.h),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "List Doctor",
                              style: TextStyle(
                                  fontSize: 3.sp, fontWeight: FontWeight.bold),
                            ),
                            Container(
                                padding: EdgeInsets.all(5.h),
                                child: SizedBox(
                                    width: double.infinity,
                                    child:
                                        _createDataTable(doctor, widget.db))),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              });
        });
  }

  DataTable _createDataTable(List<Doctor> doctor, DatabaseController uid) {
    return DataTable(columns: _createColumns(), rows: _createRows(doctor, uid));
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Specialist')),
      DataColumn(label: Text('Description')),
      DataColumn(label: Text('Start Time')),
      DataColumn(label: Text('End Time')),
      DataColumn(label: Text('Edit')),
    ];
  }

  List<DataRow> _createRows(List<Doctor> doctors, DatabaseController db) {
    return doctors
        .map((doctor) => DataRow(cells: [
              DataCell(Text(doctor.doctorName)),
              DataCell(Text(doctor.specialistname)),
              DataCell(Text(doctor.description)),
              DataCell(Text(doctor.startTime.toString())),
              DataCell(Text(doctor.endTime.toString())),
              DataCell(Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        final TextEditingController unameController =
                            TextEditingController(text: doctor.doctorName);
                        final TextEditingController udescController =
                            TextEditingController(text: doctor.description);
                        final TextEditingController ustartController =
                            TextEditingController(
                                text: doctor.startTime.toString());
                        final TextEditingController uendController =
                            TextEditingController(
                                text: doctor.endTime.toString());
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  "Update Doctor",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                actions: [
                                  Form(
                                      key: _formKey,
                                      child: const SizedBox(height: 20)),
                                  CustomTextFormField(
                                    hintText: 'Name',
                                    focusNode: nameFocus,
                                    controller: unameController,
                                    validator: (value) => value!.length <= 10
                                        ? 'less than 30 character'
                                        : null,
                                  ),
                                  SizedBox(height: 3.h),
                                  CustomTextFormField(
                                    hintText: 'Description',
                                    focusNode: descFocus,
                                    controller: udescController,
                                    validator: (value) => value!.length <= 30
                                        ? 'less than 30 character'
                                        : null,
                                  ),
                                  SizedBox(height: 3.h),
                                  CustomTextFormField(
                                    hintText: 'Start Time',
                                    focusNode: startFocus,
                                    controller: ustartController,
                                    validator: (value) => value!.length <= 10
                                        ? 'must in 24 hours'
                                        : null,
                                  ),
                                  SizedBox(height: 3.h),
                                  CustomTextFormField(
                                    hintText: 'End Time',
                                    focusNode: endFocus,
                                    controller: uendController,
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
                                      await db.updateDoctor(Doctor(
                                          id: doctor.id,
                                          doctorName: unameController.text,
                                          description: udescController.text,
                                          specialistname: doctor.specialistname,
                                          specialistId: doctor.specialistId,
                                          startTime:
                                              int.parse(ustartController.text),
                                          endTime:
                                              int.parse(uendController.text)));

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
                      icon: Icon(Icons.edit)),
                  IconButton(
                      onPressed: () async {
                        await db.deleteDoctor(doctor.id);
                      },
                      icon: Icon(Icons.delete_forever)),
                ],
              )),
            ]))
        .toList();
  }
}
