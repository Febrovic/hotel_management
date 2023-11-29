import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/card_widget.dart';
import 'package:hotel_managmenet/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hotel_managmenet/pdf_perview.dart';
import 'package:hotel_managmenet/reusable_component.dart';

class BusScreen extends StatefulWidget {
  const BusScreen(
      {Key? key, required this.clientType, required this.serviceType})
      : super(key: key);
  final int clientType;
  final int serviceType;

  @override
  State<BusScreen> createState() => _BusScreenState();
}

List<Widget> infoCard = [];

class _BusScreenState extends State<BusScreen> {
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
            .doc('hotel-$hotelDropdownValue')
            .update({service: amount});
      },
    );
  }

  int cost = 0;
  Future<void> getServicePrice() async {
    cost = await FirebaseFirestore.instance
        .collection('hotels')
        .doc('hotel-$hotelDropdownValue')
        .get()
        .then((value) {
      return widget.serviceType == 0
          ? (value.data()?['busPrice'])
          : widget.serviceType == 1
              ? (value.data()?['flightPrice'])
              : widget.serviceType == 2
                  ? (value.data()?['idBraceletPrice'])
                  : (value.data()?[
                      'hudaPrice']); // Access your after your get the data
    });
  }

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

  @override
  Widget build(BuildContext context) {
    int totalAmount = 0;
    int totalRest = 0;
    int totalNumber = 0;
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.appBarBGColor,
        centerTitle: true,
        title: Text(widget.serviceType == 0
            ? AppLocalizations.of(context)!.bus
            : widget.serviceType == 1
                ? AppLocalizations.of(context)!.flight
                : widget.serviceType == 2
                    ? AppLocalizations.of(context)!.idBracelet
                    : AppLocalizations.of(context)!.huda),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ButtonWithoutImage(
                text: widget.serviceType == 0
                    ? AppLocalizations.of(context)!.busPrice
                    : widget.serviceType == 1
                        ? AppLocalizations.of(context)!.flightPrice
                        : widget.serviceType == 2
                            ? AppLocalizations.of(context)!.idBraceletPrice
                            : AppLocalizations.of(context)!.hudaPrice,
                pressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            widget.serviceType == 0
                                ? AppLocalizations.of(context)!.busPrice
                                : widget.serviceType == 1
                                    ? AppLocalizations.of(context)!.flightPrice
                                    : widget.serviceType == 2
                                        ? AppLocalizations.of(context)!
                                            .idBraceletPrice
                                        : AppLocalizations.of(context)!
                                            .hudaPrice,
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFieldCustom(
                                labelText: widget.serviceType == 0
                                    ? AppLocalizations.of(context)!.busPrice
                                    : widget.serviceType == 1
                                        ? AppLocalizations.of(context)!
                                            .flightPrice
                                        : widget.serviceType == 2
                                            ? AppLocalizations.of(context)!
                                                .idBraceletPrice
                                            : AppLocalizations.of(context)!
                                                .hudaPrice,
                                textInputType: TextInputType.number,
                                controller: widget.serviceType == 0
                                    ? busController
                                    : widget.serviceType == 1
                                        ? flightController
                                        : widget.serviceType == 2
                                            ? idBraceletController
                                            : hudaController,
                                validate: widget.serviceType == 0
                                    ? busValidate
                                    : widget.serviceType == 1
                                        ? flightValidate
                                        : widget.serviceType == 2
                                            ? idBraceletValidate
                                            : hudaValidate,
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
                                  busController.text.isNotEmpty
                                      ? busValidate = true
                                      : busValidate = false;
                                  idBraceletController.text.isNotEmpty
                                      ? idBraceletValidate = true
                                      : idBraceletValidate = false;
                                  flightController.text.isNotEmpty
                                      ? flightValidate = true
                                      : flightValidate = false;
                                  hudaController.text.isNotEmpty
                                      ? hudaValidate = true
                                      : hudaValidate = false;
                                });
                                if (widget.serviceType == 0) {
                                  if (busValidate == true) {
                                    updateAmount('busPrice',
                                        int.parse(busController.text));
                                    Navigator.pop(context);
                                  }
                                }
                                if (widget.serviceType == 1) {
                                  if (flightValidate == true) {
                                    updateAmount('flightPrice',
                                        int.parse(flightController.text));
                                    Navigator.pop(context);
                                  }
                                }
                                if (widget.serviceType == 2) {
                                  if (idBraceletValidate == true) {
                                    updateAmount('idBraceletPrice',
                                        int.parse(busController.text));
                                    Navigator.pop(context);
                                  }
                                }
                                if (widget.serviceType == 3) {
                                  if (busValidate == true) {
                                    updateAmount('hudaPrice',
                                        int.parse(busController.text));
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child:
                                  Text(AppLocalizations.of(context)!.addAmount),
                            ),
                          ],
                        );
                      });
                },
              ),
              ButtonWithoutImage(
                text: AppLocalizations.of(context)!.print,
                pressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ServicePdfPrev(
                                totalNumber: (totalNumber ~/ 2).toString(),
                                totalAmount: totalAmount.toString(),
                                totalRest: totalRest.toString(),
                                serviceName: widget.serviceType == 0
                                    ? AppLocalizations.of(context)!.bus
                                    : widget.serviceType == 1
                                        ? AppLocalizations.of(context)!.flight
                                        : widget.serviceType == 2
                                            ? AppLocalizations.of(context)!
                                                .idBracelet
                                            : AppLocalizations.of(context)!
                                                .huda,
                              )));
                },
              ),
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
                        onChanged: (String? newValue) async {
                          setState(() {
                            hotelDropdownValue = newValue!;
                            hotels = [
                              newValue,
                            ];
                          });
                          await getServicePrice();
                          setState(() {});
                        },
                      ),
                    );
                  }),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('reservations')
                    .snapshots(),
                builder: (context, snapshot) {
                  infoCard = [];
                  if (snapshot.hasData) {
                    final clients = snapshot.data?.docs;
                    for (var client in clients!) {
                      if (hotelDropdownValue == client.data()['hotelName']) {
                        final clientName = client.data()['clientName'];
                        final clientNumber = client.data()['clientNumber'];
                        final clientNationalId =
                            client.data()['clientNationalId'];
                        final startDate = client.data()['startDate'].toDate();
                        final roomNumber = client.data()['roomNumber'];
                        final int servicePaid = widget.serviceType == 0
                            ? client.data()['paidBus']
                            : widget.serviceType == 1
                                ? client.data()['paidFlight']
                                : widget.serviceType == 2
                                    ? client.data()['paidIdBracelet']
                                    : client.data()['paidHuda'];
                        int amountRest =
                            servicePaid == 0 ? 0 : (cost - servicePaid);

                        totalAmount = totalAmount + servicePaid;
                        totalNumber =
                            servicePaid == 0 ? totalNumber : totalNumber + 1;
                        totalRest = totalRest + amountRest;
                        print("dalkfmkdsa $totalNumber");
                        infoCard.add(
                          InfoCard(
                            child: BusInfoCard(
                              clientName: clientName,
                              clientNumber: clientNumber,
                              clientNationalId: clientNationalId,
                              startDate: startDate,
                              hotelName: hotelDropdownValue,
                              roomNumber: roomNumber,
                              servicePaid: servicePaid,
                              serviceType: widget.serviceType,
                              amountRest: amountRest,
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
