import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/card_widget.dart';
import 'package:hotel_managmenet/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.appBarBGColor,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.clients),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ButtonWithoutImage(
                text: AppLocalizations.of(context)!.busPrice,
                pressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.busPrice),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFieldCustom(
                                labelText:
                                    AppLocalizations.of(context)!.busPrice,
                                textInputType: TextInputType.number,
                                controller: busController,
                                validate: busValidate,
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
                                });
                                if (busValidate == true) {
                                  updateAmount('busPrice',
                                      int.parse(busController.text));
                                  Navigator.pop(context);
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
                        final servicePaid = client.data()['paidBus'];
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
