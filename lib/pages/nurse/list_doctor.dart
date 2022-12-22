import 'package:aqhealth_web/constants/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_text_field.dart';

class ListDoctor extends StatefulWidget {
  const ListDoctor({super.key});

  @override
  State<ListDoctor> createState() => _ListDoctorState();
}

class _ListDoctorState extends State<ListDoctor> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode nameFocus = FocusNode();
  final TextEditingController nameController = TextEditingController();
  String specialist = '';
  List<String> _specialist = [
    'sergeon',
    'cardiology',
    'dentist',
    'diabetes',
    'hemodialasis',
  ];
  bool isLoading = false;
  String error = '';
  List<Map> _doctor = [
    {'id': 100, 'name': 'Dr. Ahmad', 'specialist': 'Surgeon'},
    {'id': 200, 'name': 'Dr. Mail', 'specialist': 'Surgeon'},
  ];

  

  @override
  Widget build(BuildContext context) {
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
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
                      backgroundColor: MaterialStateProperty.all(primary),
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
                                    child: const SizedBox(height: 20)),
                                CustomTextFormField(
                                  hintText: 'Name',
                                  focusNode: nameFocus,
                                  controller: nameController,
                                  validator: (value) => value!.length <= 10
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
                                      border:
                                          Border.all(color: primary, width: 2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(2.w, 0, 0, 0),
                                      child: DropdownButton(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          style: TextStyle(color: primary),
                                          hint: _specialist == null
                                              ? const Text(
                                                  'Specialist',
                                                )
                                              : Text(
                                                  specialist,
                                                  style:
                                                      TextStyle(color: primary),
                                                ),
                                          items: _specialist.map((e) {
                                            return DropdownMenuItem<String>(
                                              child: Text(e),
                                              value: e,
                                            );
                                          }).toList(),
                                          onChanged: (e) {
                                            setState(
                                              () {
                                                specialist = e as String;
                                              },
                                            );
                                          }),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
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
                                    setState(() {
                                      isLoading = true;
                                    });
                                  },
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    child: Text(
                      "Add Doctor",
                      style: TextStyle(color: Colors.white, fontSize: 4.sp),
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
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "List Doctor",
                  style: TextStyle(fontSize: 3.sp, fontWeight: FontWeight.bold),
                ),
                Container(
                    padding: EdgeInsets.all(5.h),
                    child: SizedBox(
                        width: double.infinity, child: _createDataTable())),
              ],
            ),
          ),
        ),
      ],
    );
  }

  DataTable _createDataTable() {
    return DataTable(columns: _createColumns(), rows: _createRows());
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('ID')),
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Specialist')),
    ];
  }

  List<DataRow> _createRows() {
    return _doctor
        .map((doctor) => DataRow(cells: [
              DataCell(Text('#' + doctor['id'].toString())),
              DataCell(Text(doctor['name'])),
              DataCell(Text(doctor['specialist'])),
            ]))
        .toList();
  }
}

/*Future<void> _addDoctor(BuildContext context) {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode nameFocus = FocusNode();
  final TextEditingController nameController = TextEditingController();
  String specialist = '';
  List<String> _specialist = [
    'sergeon',
    'cardiology',
    'dentist',
    'diabetes',
    'hemodialasis',
  ];
  bool isLoading = false;
  String error = '';
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Add Doctor",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          actions: [
            Form(key: _formKey, child: const SizedBox(height: 20)),
            CustomTextFormField(
              hintText: 'Name',
              focusNode: nameFocus,
              controller: nameController,
              validator: (value) =>
                  value!.length <= 10 ? 'less than 30 character' : null,
            ),
            SizedBox(
              height: 6.h,
              width: 100.w,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: primary, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(2.w, 0, 0, 0),
                  child: DropdownButton(
                      alignment: AlignmentDirectional.centerStart,
                      style: TextStyle(color: primary),
                      hint: _specialist == null
                          ? const Text(
                              'Specialist',
                            )
                          : Text(
                              specialist,
                              style: TextStyle(color: primary),
                            ),
                      items: _specialist.map((e) {
                        return DropdownMenuItem<String>(
                          child: Text(e),
                          value: e,
                        );
                      }).toList(),
                      onChanged: (e) {
                        setState(
                          () {
                            _specialist = e as String;
                          },
                        );
                      }),
                ),
              ),
            ),
            SizedBox(height: 10),
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
                setState(() {
                  isLoading = true;
                });

                if (result == null) {
                  setState(() {
                    error = 'cannot Register';
                    isLoading = false;
                  });
                }
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      });
}*/
