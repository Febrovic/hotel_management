import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/additional_services_page.dart';
import 'package:hotel_managmenet/admin_users_page.dart';
import 'package:hotel_managmenet/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:hotel_managmenet/reusable_component.dart';
import 'package:hotel_managmenet/share_capital.dart';
import 'package:hotel_managmenet/users_page.dart';

import 'employee_page.dart';

class ManagementPage extends StatefulWidget {

  final int clientType;
  final String username;
  final String hotelName;
  const ManagementPage({super.key, required this.clientType, required this.username, required this.hotelName});

  @override
  State<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  final hotelNameController = TextEditingController();
  bool hotelNameValidate = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.appBarBGColor,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.management),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: EditPasswordButton(
                    id: 'user-${widget.username}',
                    collectionName: 'users',
                    withIcon: false,
                  ),
                ),
              ),
              ButtonWithoutImage(
                  text: AppLocalizations.of(context)!.shareCapital,
                  pressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShareCapitalPage(clientType: widget.clientType,
                            )));
                  }),
              widget.clientType == 0 ? ButtonWithoutImage(
                  text: AppLocalizations.of(context)!.adminUsers,
                  pressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminUsersPage(clientType: widget.clientType,
                            )));
                  }):const SizedBox(),
              ButtonWithoutImage(
                  text: AppLocalizations.of(context)!.users,
                  pressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UsersPage(clientType: widget.clientType,
                            )));
                  }),
              ButtonWithoutImage(
                  text: AppLocalizations.of(context)!.additionalServices,
                  pressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdditionalServicesPage(hotelName: widget.hotelName,clientType: widget.clientType,)));
                  }),
              ButtonWithoutImage(
                  text: AppLocalizations.of(context)!.employeesInformation,
                  pressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmployeesPage(
                              clientType: widget.clientType,
                            )));
                  }),
              ButtonWithoutImage(
                  text: AppLocalizations.of(context)!.addHotel,
                  pressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.addHotel),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFieldCustom(
                                  labelText:
                                  AppLocalizations.of(context)!.hotelName,
                                  textInputType: TextInputType.text,
                                  controller: hotelNameController,
                                  validate: hotelNameValidate,
                                ),
                              ],
                            ),
                            actions: [
                              MaterialButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                child:
                                Text(AppLocalizations.of(context)!.dismiss),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    hotelNameController.text.isNotEmpty
                                        ? hotelNameValidate = true
                                        : hotelNameValidate = false;
                                  });
                                  if (hotelNameValidate == true) {
                                    final CollectionReference postsRef =
                                    FirebaseFirestore.instance
                                        .collection('hotels');
                                    var postID =
                                        'hotel-${hotelNameController.text}';
                                    DocumentReference ref =
                                    postsRef.doc(postID);
                                    ref.set({
                                      'clients': 0,
                                      'hotelName': hotelNameController.text,
                                      'reservations': 0,
                                      'totalIncome': 0,
                                      'totalOutcome': 0,
                                      'totalRest': 0,
                                      'clientType':widget.clientType,
                                      'idBraceletPrice':0,
                                      'busPrice':0,
                                      'hudaPrice':0,
                                      'flightPrice':0,
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                    AppLocalizations.of(context)!.addHotel),
                              ),
                            ],
                          );
                        });
                  }),
              EditHotelButton(id: 'hotel-${widget.hotelName}', collectionName: 'hotels',),
              BigDeleteButton(id: 'hotel-${widget.hotelName}',collectionName: 'hotels',),
            ],
          ),
        ),
      ),
    );
  }
}
