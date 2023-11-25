import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/constants.dart';
import 'package:hotel_managmenet/employee_page.dart';
import 'package:hotel_managmenet/management_page.dart';
import 'package:hotel_managmenet/outcome_page.dart';
import 'package:hotel_managmenet/pdf_perview.dart';
import 'package:hotel_managmenet/reservations_page.dart';
import 'package:hotel_managmenet/reusable_component.dart';
import 'package:hotel_managmenet/rooms_report.dart';
import 'package:hotel_managmenet/users_page.dart';
import 'card_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class Reports extends StatefulWidget {
  final int clientType;
  final String username;

  const Reports({super.key, required this.clientType, required this.username});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final hotelNameController = TextEditingController();
  bool usernameValidate = true;
  bool passwordValidate = true;
  bool hotelNameValidate = true;
  String hotelDropdownValue = 'اسم الفندق';
  var hotels = [
    'اسم الفندق',
  ];
  int? clientTypeCreate;
  Future<void> getClientType() async {
    clientTypeCreate = await FirebaseFirestore.instance
        .collection('clients')
        .doc('clientNumber')
        .get()
        .then((value) {
      return value
          .data()?['clientNumber']; // Access your after your get the data
    });

    clientTypeCreate = (clientTypeCreate! + 1);
  }

  Future<void> updateClientNumber() async {
    await FirebaseFirestore.instance.collection("clients").get().then(
      (querySnapshot) {
        FirebaseFirestore.instance
            .collection('clients')
            .doc('clientNumber')
            .update({'clientNumber': clientTypeCreate});
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.appBarBGColor,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.reports),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              widget.clientType == 0
                  ? ButtonWithoutImage(
                      text: AppLocalizations.of(context)!.addClient,
                      pressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    AppLocalizations.of(context)!.addClient),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFieldCustom(
                                      labelText: AppLocalizations.of(context)!
                                          .userName,
                                      textInputType: TextInputType.text,
                                      controller: usernameController,
                                      validate: usernameValidate,
                                    ),
                                    TextFieldCustom(
                                      labelText: AppLocalizations.of(context)!
                                          .password,
                                      textInputType:
                                          TextInputType.visiblePassword,
                                      controller: passwordController,
                                      validate: passwordValidate,
                                    ),
                                  ],
                                ),
                                actions: [
                                  MaterialButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.dismiss),
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      setState(() {
                                        usernameController.text.isNotEmpty
                                            ? usernameValidate = true
                                            : usernameValidate = false;
                                        passwordController.text.isNotEmpty
                                            ? passwordValidate = true
                                            : passwordValidate = false;
                                      });
                                      if (usernameValidate == true &&
                                          passwordValidate == true) {
                                        await getClientType();
                                        final CollectionReference postsRef =
                                            FirebaseFirestore.instance
                                                .collection('users');
                                        var postID =
                                            'user-${usernameController.text}';
                                        DocumentReference ref =
                                            postsRef.doc(postID);
                                        ref.set({
                                          'username': usernameController.text,
                                          'password': passwordController.text,
                                          'userType': 1,
                                          'clientType': clientTypeCreate,
                                        });
                                        await updateClientNumber();
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.addUser),
                                  ),
                                ],
                              );
                            });
                      })
                  : SizedBox(),
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
              InfoCard(
                child: RoomReportsInfoCard(
                  hotelName: hotelDropdownValue,
                ),
              ),
              ButtonWithoutImage(
                  text: AppLocalizations.of(context)!.reservationReport,
                  pressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RoomsReport(
                                  clientType: widget.clientType,
                                )));
                  }),
              ButtonWithoutImage(
                  text: AppLocalizations.of(context)!.outcome,
                  pressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OutcomePage(
                                  hotelName: hotelDropdownValue,
                                )));
                  }),
              ButtonWithoutImage(
                  text: AppLocalizations.of(context)!.management,
                  pressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManagementPage(
                              hotelName: hotelDropdownValue,
                                  clientType: widget.clientType,
                              username: widget.username,
                                )));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
