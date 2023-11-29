import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/constants.dart';
import 'card_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoomsReport extends StatefulWidget {
  final int clientType;

  const RoomsReport({super.key, required this.clientType});

  @override
  State<RoomsReport> createState() => _RoomsReportState();
}

List<Widget> infoCard = [];

class _RoomsReportState extends State<RoomsReport> {
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

  Future<void> updateRoomState() async {
    await FirebaseFirestore.instance.collection("reservations").get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          DateTime startDateDB = docSnapshot.data()['startDate'].toDate();
          DateTime endDateDB = docSnapshot.data()['endDate'].toDate();
          String roomNum = docSnapshot.data()['roomNumber'];
          if (endDateDB.difference(startDateDB).inDays <= 0) {
            FirebaseFirestore.instance
                .collection('rooms')
                .doc('room$roomNum')
                .update({'reservationState': false});
          } else {
            FirebaseFirestore.instance
                .collection('rooms')
                .doc('room$roomNum')
                .update({'reservationState': true});
          }
        }
      },
    );
  }



  int selectedRadio = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.appBarBGColor,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.reservationReport),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
              InfoCard(
                child: RoomReportsInfoCard(
                  hotelName: hotelDropdownValue,
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: selectedRadio,
                        onChanged: (val) {
                          setState(() {
                            selectedRadio = val!;
                          });
                        },
                        activeColor: const Color(0xFF57375D),
                      ),
                      Text(AppLocalizations.of(context)!.availableRooms),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: selectedRadio,
                        onChanged: (val) {
                          setState(() {
                            selectedRadio = val!;
                          });
                        },
                        activeColor: const Color(0xFF57375D),
                      ),
                      Text(AppLocalizations.of(context)!.reservedRooms),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 3,
                        groupValue: selectedRadio,
                        onChanged: (val) {
                          setState(() {
                            selectedRadio = val!;
                          });
                        },
                        activeColor: const Color(0xFF57375D),
                      ),
                      Text(AppLocalizations.of(context)!.maintenanceRoom),
                    ],
                  ),
                ],
              ),
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('rooms').snapshots(),
                builder: (context, snapshot) {
                  updateRoomState();
                  infoCard = [];
                  if (snapshot.hasData) {
                    final room = snapshot.data?.docs;
                    for (var roomy in room!) {
                      if (hotelDropdownValue == roomy.data()['hotelName']) {
                        final roomNumber = roomy.data()['roomNumber'];
                        final bedNumber = roomy.data()['bedNumber'];
                        final bathroomType = roomy.data()['bathroomType'];
                        final reservationState = roomy.data()['reservationState'];
                        final roomStatus = roomy.data()['roomStatus'];
                        final clientName = roomy.data()['clientName'];
                        final clientNationalId = roomy.data()['clientNationalId'];
                        final startDate = roomy.data()['startDate'].toDate();
                        final endDate = roomy.data()['endDate'].toDate();

                        if(selectedRadio == 1){
                          if(reservationState == false){
                            infoCard.add(
                              InfoCard(
                                child: RoomReportInfoCard(
                                  roomNumber: roomNumber,
                                  bedNumber: bedNumber,
                                  bathroomType: bathroomType,
                                  reservationState: false,
                                  selectedRadio: 1, clientName: clientName, clientNationalId: clientNationalId, startDate: startDate, endDate: endDate,
                                ),
                              ),
                            );
                          }
                        }
                        if(selectedRadio == 2){
                          if(reservationState == true){
                            infoCard.add(
                              InfoCard(
                                child: RoomReportInfoCard(
                                  roomNumber: roomNumber,
                                  bedNumber: bedNumber,
                                  bathroomType: bathroomType,
                                  reservationState: true,
                                  selectedRadio: 2,clientName: clientName, clientNationalId: clientNationalId, startDate: startDate, endDate: endDate,
                                ),
                              ),
                            );
                          }
                        }
                        if(selectedRadio == 3){
                          if(roomStatus == 'صيانه' || roomStatus == 'صيانة'){
                            infoCard.add(
                              InfoCard(
                                child: RoomReportInfoCard(
                                  roomNumber: roomNumber,
                                  bedNumber: bedNumber,
                                  bathroomType: bathroomType,
                                  reservationState: false,
                                  selectedRadio: 3,clientName: clientName, clientNationalId: clientNationalId, startDate: startDate, endDate: endDate,
                                ),
                              ),
                            );
                          }
                        }
                      }
                    }
                    return infoCard.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Center(
                              child: Text(
                                  AppLocalizations.of(context)!.noRoomsYet),
                            ),
                          )
                        : Column(
                            children: infoCard,
                          );
                  } else {
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
