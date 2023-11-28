import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/bus_page.dart';
import 'package:hotel_managmenet/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:hotel_managmenet/reusable_component.dart';

class AdditionalServicesPage extends StatefulWidget {
  const AdditionalServicesPage({Key? key, required this.hotelName, required this.clientType})
      : super(key: key);
  final String hotelName;
  final int clientType;

  @override
  State<AdditionalServicesPage> createState() => _AdditionalServicesPageState();
}

class _AdditionalServicesPageState extends State<AdditionalServicesPage> {
  final busController = TextEditingController();
  final idBraceletController = TextEditingController();
  final hudaController = TextEditingController();
  final flightController = TextEditingController();
  bool busValidate = true;
  bool idBraceletValidate = true;
  bool hudaValidate = true;
  bool flightValidate = true;

  Future<void> updateAmount(String service, int amount) async {
    await FirebaseFirestore.instance.collection('hotels').get().then(
      (querySnapshot) {
        FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-${widget.hotelName}')
            .update({service: amount});
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
        title: Text(AppLocalizations.of(context)!.shareCapital),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ButtonWithoutImage(
                  text: AppLocalizations.of(context)!.bus,
                  pressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  BusScreen(clientType: widget.clientType, serviceType: 0,),
                      ),
                    );
                  }
                  //     () {
                  //   showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title: Text(AppLocalizations.of(context)!.busPrice),
                  //           content: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               TextFieldCustom(
                  //                 labelText:
                  //                 AppLocalizations.of(context)!.busPrice,
                  //                 textInputType: TextInputType.number,
                  //                 controller: busController,
                  //                 validate: busValidate,
                  //               ),
                  //             ],
                  //           ),
                  //           actions: [
                  //             MaterialButton(
                  //               onPressed: () async {
                  //                 Navigator.pop(context);
                  //               },
                  //               child:
                  //               Text(AppLocalizations.of(context)!.dismiss),
                  //             ),
                  //             MaterialButton(
                  //               onPressed: () {
                  //                 setState(() {
                  //                   busController.text.isNotEmpty
                  //                       ? busValidate = true
                  //                       : busValidate = false;
                  //                 });
                  //                 if (busValidate == true) {
                  //                   updateAmount('busPrice', int.parse(busController.text));
                  //                   Navigator.pop(context);
                  //                 }
                  //               },
                  //               child:
                  //               Text(AppLocalizations.of(context)!.addAmount),
                  //             ),
                  //           ],
                  //         );
                  //       });
                  // },
                  ),
            ),
            Expanded(
              child: ButtonWithoutImage(
                  text: AppLocalizations.of(context)!.flight,
                  pressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  BusScreen(clientType: widget.clientType, serviceType: 1,),
                      ),
                    );
                  },
                  // () {
                  //   showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title:
                  //               Text(AppLocalizations.of(context)!.flightPrice),
                  //           content: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               TextFieldCustom(
                  //                 labelText:
                  //                     AppLocalizations.of(context)!.flightPrice,
                  //                 textInputType: TextInputType.number,
                  //                 controller: flightController,
                  //                 validate: flightValidate,
                  //               ),
                  //             ],
                  //           ),
                  //           actions: [
                  //             MaterialButton(
                  //               onPressed: () async {
                  //                 Navigator.pop(context);
                  //               },
                  //               child:
                  //                   Text(AppLocalizations.of(context)!.dismiss),
                  //             ),
                  //             MaterialButton(
                  //               onPressed: () {
                  //                 setState(() {
                  //                   flightController.text.isNotEmpty
                  //                       ? flightValidate = true
                  //                       : flightValidate = false;
                  //                 });
                  //                 if (flightValidate == true) {
                  //                   updateAmount('flightPrice',
                  //                       int.parse(flightController.text));
                  //                   Navigator.pop(context);
                  //                 }
                  //               },
                  //               child: Text(
                  //                   AppLocalizations.of(context)!.addAmount),
                  //             ),
                  //           ],
                  //         );
                  //       });
                  // },
              ),
            ),
            Expanded(
              child: ButtonWithoutImage(
                  text: AppLocalizations.of(context)!.idBracelet,
                  pressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  BusScreen(clientType: widget.clientType, serviceType: 2,),
                      ),
                    );
                  },
                  //     () {
                  //   showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title:
                  //               Text(AppLocalizations.of(context)!.idBracelet),
                  //           content: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               TextFieldCustom(
                  //                 labelText: AppLocalizations.of(context)!
                  //                     .idBraceletPrice,
                  //                 textInputType: TextInputType.number,
                  //                 controller: idBraceletController,
                  //                 validate: idBraceletValidate,
                  //               ),
                  //             ],
                  //           ),
                  //           actions: [
                  //             MaterialButton(
                  //               onPressed: () async {
                  //                 Navigator.pop(context);
                  //               },
                  //               child:
                  //                   Text(AppLocalizations.of(context)!.dismiss),
                  //             ),
                  //             MaterialButton(
                  //               onPressed: () {
                  //                 setState(() {
                  //                   idBraceletController.text.isNotEmpty
                  //                       ? idBraceletValidate = true
                  //                       : idBraceletValidate = false;
                  //                 });
                  //                 if (idBraceletValidate == true) {
                  //                   updateAmount('idBraceletPrice',
                  //                       int.parse(idBraceletController.text));
                  //                   Navigator.pop(context);
                  //                 }
                  //               },
                  //               child: Text(
                  //                   AppLocalizations.of(context)!.addAmount),
                  //             ),
                  //           ],
                  //         );
                  //       });
                  // },
              ),
            ),
            Expanded(
              child: ButtonWithoutImage(
                  text: AppLocalizations.of(context)!.huda,
                  pressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  BusScreen(clientType: widget.clientType, serviceType: 3,),
                      ),
                    );
                  }
                  //     () {
                  //   showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title:
                  //               Text(AppLocalizations.of(context)!.hudaPrice),
                  //           content: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               TextFieldCustom(
                  //                 labelText:
                  //                     AppLocalizations.of(context)!.hudaPrice,
                  //                 textInputType: TextInputType.number,
                  //                 controller: hudaController,
                  //                 validate: hudaValidate,
                  //               ),
                  //             ],
                  //           ),
                  //           actions: [
                  //             MaterialButton(
                  //               onPressed: () async {
                  //                 Navigator.pop(context);
                  //               },
                  //               child:
                  //                   Text(AppLocalizations.of(context)!.dismiss),
                  //             ),
                  //             MaterialButton(
                  //               onPressed: () {
                  //                 setState(() {
                  //                   hudaController.text.isNotEmpty
                  //                       ? hudaValidate = true
                  //                       : hudaValidate = false;
                  //                 });
                  //                 if (hudaValidate == true) {
                  //                   updateAmount('hudaPrice',
                  //                       int.parse(hudaController.text));
                  //                   Navigator.pop(context);
                  //                 }
                  //               },
                  //               child: Text(
                  //                   AppLocalizations.of(context)!.addAmount),
                  //             ),
                  //           ],
                  //         );
                  //       });
                  // }
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
