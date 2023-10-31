import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/constants.dart';
import 'card_widget.dart';
import 'new_reservation_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ReservationsPage extends StatefulWidget {

  final int? userType;
  final int clientType;

  const ReservationsPage({super.key, this.userType, required this.clientType});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

List<Widget> infoCard = [
];


class _ReservationsPageState extends State<ReservationsPage> {
  final _firestore = FirebaseFirestore.instance;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.appBarBGColor,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.reservations),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:
            [
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewReservation(clientType: widget.clientType,)));
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

              FutureBuilder(
                  future: getHotelName(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    var seen = <String>{};
                    List<String> uniqueList = hotels
                        .where((hotel) => seen.add(hotel))
                        .toList();
                    if(hotels.isEmpty){
                      return const CircularProgressIndicator();
                    }
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
                stream: _firestore.collection('reservations').snapshots(),
                builder: (context, snapshot) {
                  infoCard=[];
                  if (snapshot.hasData) {
                    final reservation = snapshot.data?.docs;
                    for (var reserve in reservation!) {
                      if(hotelDropdownValue == reserve.data()['hotelName']){
                        final clientName = reserve.data()['clientName'];
                        final clientNumber = reserve.data()['clientNumber'];
                        final clientNationalId =
                        reserve.data()['clientNationalId'];
                        final hotelName = reserve.data()['hotelName'];
                        final nationality = reserve.data()['nationality'];
                        final roomNumber = reserve.data()['roomNumber'];
                        final startDate = reserve.data()['startDate'].toDate();
                        final endDate = reserve.data()['endDate'].toDate();
                        final reservationNumber = reserve.data()['reservationNumber'];
                        final amountPaid= reserve.data()['amountPaid'];
                        infoCard.add(
                          InfoCard(
                            child: ReservationInfoCard(
                              reservationNumber: reservationNumber,
                              clientName: clientName,
                              clientNumber: clientNumber,
                              clientNationalId: clientNationalId,
                              hotelName: hotelName,
                              roomNumber: roomNumber,
                              startDate: startDate,
                              endDate: endDate,
                              amountPaid: amountPaid,
                              userType: widget.userType,
                              nationality: nationality,
                            ),
                          ),
                        );
                      }
                    }
                    return infoCard.isEmpty? Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Center(child: Text(AppLocalizations.of(context)!.noReservationsYet),),
                    ):Column(
                      children: infoCard,
                    );
                  }else{
                    return const Center(child: CircularProgressIndicator());
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

