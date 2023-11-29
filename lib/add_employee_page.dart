import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_managmenet/add_data.dart';
import 'package:hotel_managmenet/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hotel_managmenet/reusable_component.dart';
import 'package:image_picker/image_picker.dart';

class NewEmployeePage extends StatefulWidget {
  final int clientType;

  const NewEmployeePage({super.key, required this.clientType});

  @override
  State<NewEmployeePage> createState() => _NewEmployeePageState();
}

class _NewEmployeePageState extends State<NewEmployeePage> {
  String hotelDropdownValue = 'اسم الفندق';
  var hotels = [
    'اسم الفندق',
  ];
  Future<void> getHotelName() async {
    await FirebaseFirestore.instance.collection("hotels").get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.data()['clientType'] == widget.clientType ||
              widget.clientType == 0) {
            hotels.add(docSnapshot.data()['hotelName'].toString());
          }
        }
      },
    );
  }

  Uint8List? _image;
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
  }

  String resp = 'no link';
  bool comp = false;
  Future<void> saveImage() async {
    if (_image == null) {
      String imageUrl = 'https://static.thenounproject.com/png/897141-200.png';
      Uint8List defaultImage =
          (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl))
              .buffer
              .asUint8List();
      resp = await StoreData().saveDataEmployee(
        file: defaultImage,
        employeeName: employeeNameController.text,
      );
      comp = true;
    } else {
      resp = await StoreData().saveDataEmployee(
        file: _image!,
        employeeName: employeeNameController.text,
      );
      comp = true;
    }
  }

  final employeeNameController = TextEditingController();
  final employeeNumberController = TextEditingController();
  final employeeTaskController = TextEditingController();
  final employeeTitleJobController = TextEditingController();
  final employeeSalaryController = TextEditingController();

  bool employeeNameValidate = true;
  bool employeeNumberValidate = true;
  bool employeeTaskValidate = true;
  bool employeeTitleJobValidate = true;
  bool employeeSalaryValidate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.appBarBGColor,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.addEmployee),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
                future: getHotelName(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  var seen = <String>{};
                  List<String> uniqueList =
                      hotels.where((hotel) => seen.add(hotel)).toList();
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: DropdownButtonFormField(
                      style: const TextStyle(
                        color: Color(0xFF176B87),
                      ),
                      value: uniqueList[0],
                      decoration: InputDecoration(
                        iconColor: Colors.orange,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF176B87)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      items: uniqueList.map((String hotels) {
                        return DropdownMenuItem(
                          value: hotels,
                          child: Text(hotels),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          hotelDropdownValue = newValue!;
                          hotels = [
                            newValue,
                          ];
                        });
                      },
                    ),
                  );
                }),
            TextFieldCustom(
              labelText: AppLocalizations.of(context)!.employeeName,
              textInputType: TextInputType.text,
              controller: employeeNameController,
              validate: employeeNameValidate,
            ),
            TextFieldCustom(
              labelText: AppLocalizations.of(context)!.employeeTitleJob,
              textInputType: TextInputType.text,
              controller: employeeTitleJobController,
              validate: employeeTitleJobValidate,
            ),
            TextFieldCustom(
              labelText: AppLocalizations.of(context)!.employeeNumber,
              textInputType: TextInputType.number,
              controller: employeeNumberController,
              validate: employeeNumberValidate,
            ),
            TextFieldCustom(
              labelText: AppLocalizations.of(context)!.employeeTask,
              textInputType: TextInputType.text,
              controller: employeeTaskController,
              validate: employeeTaskValidate,
            ),
            TextFieldCustom(
              labelText: AppLocalizations.of(context)!.employeeSalary,
              textInputType: TextInputType.number,
              controller: employeeSalaryController,
              validate: employeeSalaryValidate,
            ),
            ButtonWithoutImage(
              text: AppLocalizations.of(context)!.employeeImage,
              pressed: selectImage,
            ),
            ButtonWithoutImage(
              text: AppLocalizations.of(context)!.addEmployee,
              pressed: () async {
                setState(() {
                  employeeNameController.text.isNotEmpty
                      ? employeeNameValidate = true
                      : employeeNameValidate = false;
                  employeeNumberController.text.isNotEmpty
                      ? employeeNumberValidate = true
                      : employeeNumberValidate = false;
                  employeeSalaryController.text.isNotEmpty
                      ? employeeSalaryValidate = true
                      : employeeSalaryValidate = false;
                  employeeTaskController.text.isNotEmpty
                      ? employeeTaskValidate = true
                      : employeeTaskValidate = false;
                  employeeTitleJobController.text.isNotEmpty
                      ? employeeTitleJobValidate = true
                      : employeeTitleJobValidate = false;
                });
                if (employeeNameValidate &&
                    employeeNumberValidate &&
                    employeeSalaryValidate &&
                    employeeTaskValidate &&
                    employeeTitleJobValidate) {
                  await saveImage();
                  final CollectionReference postsRef =
                      FirebaseFirestore.instance.collection('employees');
                  var postID = 'employee-${employeeNameController.text}';
                  DocumentReference ref = postsRef.doc(postID);
                  ref.set({
                    'employeeName': employeeNameController.text,
                    'employeeTask': employeeTaskController.text,
                    'employeeTitleJob': employeeTitleJobController.text,
                    'employeeNumber': int.parse(employeeNumberController.text),
                    'employeeSalary': int.parse(employeeSalaryController.text),
                    'hotelName': hotelDropdownValue,
                    'imageLink': resp,
                  });
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }
}
