import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:hotel_managmenet/reusable_component.dart';

import 'card_widget.dart';

class AdminUsersPage extends StatefulWidget {
  final int clientType;

  const AdminUsersPage({super.key, required this.clientType});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}
List<Widget> infoCard = [];
class _AdminUsersPageState extends State<AdminUsersPage> {

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
  Future<void> getHotelName() async {
    await FirebaseFirestore.instance.collection("hotels").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if(docSnapshot.data()['clientType']==widget.clientType || widget.clientType==0 ){
            hotels.add(docSnapshot.data()['hotelName'].toString());
          }
        }
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.appBarBGColor,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.adminUsers),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ButtonWithoutImage(
                  text: AppLocalizations.of(context)!.addClient,
                  pressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.addClient),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFieldCustom(
                                  labelText:
                                  AppLocalizations.of(context)!.userName,
                                  textInputType: TextInputType.text,
                                  controller: usernameController,
                                  validate: usernameValidate,
                                ),
                                TextFieldCustom(
                                  labelText:
                                  AppLocalizations.of(context)!.password,
                                  textInputType: TextInputType.visiblePassword,
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
                                child:
                                Text(AppLocalizations.of(context)!.dismiss),
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
                                      'clientType':clientTypeCreate,
                                    });
                                    await updateClientNumber();
                                    Navigator.pop(context);
                                  }
                                },
                                child:
                                Text(AppLocalizations.of(context)!.addUser),
                              ),
                            ],
                          );
                        });
                  }),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  infoCard = [];
                  if (snapshot.hasData) {
                    final users = snapshot.data?.docs;
                    for (var user in users!) {
                      if(widget.clientType == 0 &&user.data()['userType']==1){
                        final username = user.data()['username'];
                        final password = user.data()['password'];
                        infoCard.add(
                          InfoCard(
                            child: UsersInfoCard(
                              username: username,
                              password:password,
                            ),
                          ),
                        );
                      }
                    }
                    return infoCard.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: Text(
                            AppLocalizations.of(context)!.noClientsYet),
                      ),
                    )
                        : Column(
                      children: infoCard,
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
