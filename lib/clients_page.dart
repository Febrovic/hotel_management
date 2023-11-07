import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:hotel_managmenet/constants.dart';
import 'package:hotel_managmenet/pdf_perview.dart';
import 'package:hotel_managmenet/reusable_component.dart';

import 'card_widget.dart';

class ClientsPage extends StatefulWidget {
  final int? userType;
  final int clientType;

  const ClientsPage({super.key, this.userType, required this.clientType});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

List<Widget> infoCard = [];
class _ClientsPageState extends State<ClientsPage> {
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


  final _firestore = FirebaseFirestore.instance;
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
                stream: _firestore.collection('reservations').doc().collection('clients').snapshots(),
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
                        final nationality = client.data()['nationality'];
                        final numberOfTheClient =
                            client.data()['numberOfTheClient'];
                        final startDate = client.data()['startDate'].toDate();
                        final clientRate = client.data()['clientRate'];
                        final bus = client.data()['bus'];
                        final flight = client.data()['flight'];
                        final huda = client.data()['huda'];
                        final idBracelet = client.data()['idBracelet'];
                        infoCard.add(
                          InfoCard(
                            child: ClientInfoCard(
                              clientName: clientName,
                              clientNumber: clientNumber,
                              clientNationalId: clientNationalId,
                              nationality: nationality,
                              numberOfTheClient: numberOfTheClient,
                              startDate: startDate,
                              clientRate: clientRate,
                              userType: widget.userType!,
                              bus:bus, flight: flight, idBracelet: idBracelet, huda: huda,
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
