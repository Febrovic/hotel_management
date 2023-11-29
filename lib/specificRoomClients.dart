import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hotel_managmenet/card_widget.dart';
import 'package:hotel_managmenet/new_exist_reserv.dart';
import 'package:hotel_managmenet/new_reservation_page.dart';

import 'constants.dart';

class SpecificRoomClients extends StatefulWidget {
  final int userType;
  final String hotelName;
  final String roomNumber;
  final DateTime startDate;
  final DateTime endDate;
  final int amountPaid;
  final int bedNumber;
  const SpecificRoomClients({Key? key, required this.userType, required this.hotelName, required this.roomNumber, required this.startDate, required this.bedNumber, required this.endDate, required this.amountPaid}) : super(key: key);

  @override
  State<SpecificRoomClients> createState() => _SpecificRoomClientsState();
}
List<Widget> infoCard = [];
class _SpecificRoomClientsState extends State<SpecificRoomClients> {

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
              Padding(
                padding:
                const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF176B87)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if(widget.bedNumber>infoCard.length){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  NewExistReserveScreen(hotelName: widget.hotelName, roomNumber: widget.roomNumber, startDate: widget.startDate, amountPaid:  widget.amountPaid, endDate:  widget.endDate, )));
                    }else{
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(AppLocalizations.of(context)!.addReservation),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(AppLocalizations.of(context)!.noSpace),
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
                              ],
                            );
                          });
                    }

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        size: 30,
                      ),
                      Text(
                        AppLocalizations.of(context)!.addReservation,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                stream: _firestore.collection('clientsInsideRooms').snapshots(),
                builder: (context, snapshot) {
                  infoCard = [];
                  if (snapshot.hasData) {

                    final clients = snapshot.data?.docs;

                    for (var client in clients!) {
                      if (widget.hotelName == client.data()['hotelName']) {
                        if(widget.roomNumber == client.data()['roomNumber']){
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
                                userType: widget.userType,
                                bus:bus, flight: flight, idBracelet: idBracelet, huda: huda,
                              ),
                            ),
                          );
                        }
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
