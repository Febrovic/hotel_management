import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/constants.dart';
import 'card_widget.dart';
import 'new_room_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoomsPage extends StatefulWidget {
  final int? userType;
  final int clientType;

  const RoomsPage({super.key, this.userType, required this.clientType});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

List<Widget> infoCard = [];

class _RoomsPageState extends State<RoomsPage> {
  final _firestore = FirebaseFirestore.instance;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.appBarBGColor,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.rooms),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            widget.userType == 1
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
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
                                builder: (context) => NewRoom(
                                      clientType: widget.clientType,
                                    )));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add,
                            size: 30,
                          ),
                          Text(
                            AppLocalizations.of(context)!.addRoom,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
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
              stream: _firestore.collection('rooms').snapshots(),
              builder: (context, snapshot) {
                updateRoomState();
                infoCard = [];
                if (snapshot.hasData) {
                  final room = snapshot.data?.docs;
                  for (var roomy in room!) {
                    if (hotelDropdownValue == roomy.data()['hotelName']) {
                      final roomNumber = roomy.data()['roomNumber'];
                      final roomStatus = roomy.data()['roomStatus'];
                      final bedNumber = roomy.data()['bedNumber'];
                      final bathroomType = roomy.data()['bathroomType'];
                      final reservationState = roomy.data()['reservationState'];
                      final tv = roomy.data()['tv'];
                      final fridge = roomy.data()['fridge'];
                      final washingMachine = roomy.data()['washingMachine'];
                      final kettle = roomy.data()['kettle'];
                      final coffeeMachine = roomy.data()['coffeeMachine'];
                      final curtains = roomy.data()['curtains'];
                      final hotelName = roomy.data()['hotelName'];
                      final roomType = roomy.data()['roomType'];
                      final roomPrice = roomy.data()['roomPrice'];

                      infoCard.add(
                        InfoCard(
                          child: RoomInfoCard(
                            roomNumber: roomNumber,
                            roomStatus: roomStatus,
                            reservationState: reservationState,
                            bedNumber: bedNumber,
                            tv: tv,
                            fridge: fridge,
                            washingMachine: washingMachine,
                            kettle: kettle,
                            coffeeMachine: coffeeMachine,
                            curtains: curtains,
                            hotelName: hotelName,
                            roomType: roomType,
                            roomPrice: roomPrice,
                            bathroomType: bathroomType,
                            userType: widget.userType,
                          ),
                        ),
                      );
                    }
                  }
                  return infoCard.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Center(
                            child:
                                Text(AppLocalizations.of(context)!.noRoomsYet),
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
          ]),
        ),
      ),
    );
  }
}
