import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/constants.dart';
import 'reusable_component.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewRoom extends StatefulWidget {
  final int clientType;

  const NewRoom({super.key, required this.clientType});

  @override
  State<NewRoom> createState() => _NewRoomState();

}

class _NewRoomState extends State<NewRoom> {
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
  bool validate = true;



  final roomNumberController = TextEditingController();
  final roomPriceController = TextEditingController();
  final roomTypeController = TextEditingController();
  final roomStatusController = TextEditingController();
  final bedNumberController = TextEditingController();

  bool roomNumberValidate = true;
  bool roomPriceValidate = true;
  bool roomTypeValidate = true;
  bool roomStatusValidate = true;
  bool bedNumberValidate = true;

  bool? tv = false;
  bool? fridge = false;
  bool? washingMachine = false;
  bool? kettle = false;
  bool? coffeeMachine = false;
  bool? curtains = false;
  String finBath=' ';

  @override
  Widget build(BuildContext context) {


    String bathroomDropdownValue = AppLocalizations.of(context)!.chooseBathroomType;
    var bathrooms = [
      AppLocalizations.of(context)!.chooseBathroomType,
      AppLocalizations.of(context)!.internal,
      AppLocalizations.of(context)!.external,
      AppLocalizations.of(context)!.shared,
    ];

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.appBarBGColor,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.addRoom),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            TextFieldCustom(
              labelText: AppLocalizations.of(context)!.roomNumber,
              textInputType: TextInputType.text,
              controller: roomNumberController,
              validate:roomNumberValidate,
            ),
            TextFieldCustom(
              labelText: AppLocalizations.of(context)!.roomType,
              textInputType: TextInputType.text,
              controller: roomTypeController,
              validate:roomTypeValidate,
            ),
            TextFieldCustom(
              labelText: AppLocalizations.of(context)!.bedNumber,
              textInputType: TextInputType.number,
              controller: bedNumberController,
              validate: bedNumberValidate,
            ),
            Padding(
              padding:
              const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: DropdownButtonFormField(
                style: const TextStyle(
                  color: Color(0xFF176B87),
                ),
                value: bathroomDropdownValue,
                decoration: InputDecoration(
                  iconColor: Colors.orange,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF176B87)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                items: bathrooms.map((String bathrooms) {
                  return DropdownMenuItem(
                    value: bathrooms,
                    child: Text(bathrooms),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    bathroomDropdownValue = newValue!;
                    finBath = bathroomDropdownValue;
                  });
                },
              ),
            ),
            TextFieldCustom(
              labelText: AppLocalizations.of(context)!.roomPrice,
              textInputType: TextInputType.number,
              controller: roomPriceController,
              validate:roomPriceValidate,

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0),
                      child: Row(
                        children: <Widget>[
                          //SizedBox
                          Text(
                            AppLocalizations.of(context)!.tv,
                            style: const TextStyle(fontSize: 17.0),
                          ), //Text
                          /** Checkbox Widget **/
                          Checkbox(
                              value: tv,
                              onChanged: (value) {
                                setState(() {
                                  tv = value;
                                });
                              }), //Checkbox
                        ], //<Widget>[]
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0),
                      child: Row(
                        children: <Widget>[
                          //SizedBox
                          Text(
                            AppLocalizations.of(context)!.fridge,
                            style: const TextStyle(fontSize: 17.0),
                          ), //Text
                          /** Checkbox Widget **/
                          Checkbox(
                              value: fridge,
                              onChanged: (value) {
                                setState(() {
                                  fridge = value;
                                });
                              }), //Checkbox
                        ], //<Widget>[]
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0),
                      child: Row(
                        children: <Widget>[
                          //SizedBox
                          Text(
                            AppLocalizations.of(context)!.coffeeMachine,
                            style: const TextStyle(fontSize: 17.0),
                          ), //Text
                          /** Checkbox Widget **/
                          Checkbox(
                              value: coffeeMachine,
                              onChanged: (value) {
                                setState(() {
                                  coffeeMachine = value;
                                });
                              }), //Checkbox
                        ], //<Widget>[]
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0),
                      child: Row(
                        children: <Widget>[
                          //SizedBox
                          Text(
                            AppLocalizations.of(context)!.washingMachine,
                            style: const TextStyle(fontSize: 17.0),
                          ), //Text
                          /** Checkbox Widget **/
                          Checkbox(
                              value: washingMachine,
                              onChanged: (value) {
                                setState(() {
                                  washingMachine = value;
                                });
                              }), //Checkbox
                        ], //<Widget>[]
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0),
                      child: Row(
                        children: <Widget>[
                          //SizedBox
                          Text(
                            AppLocalizations.of(context)!.kettle,
                            style: const TextStyle(fontSize: 17.0),
                          ), //Text
                          /** Checkbox Widget **/
                          Checkbox(
                              value: kettle,
                              onChanged: (value) {
                                setState(() {
                                  kettle = value;
                                });
                              }), //Checkbox
                        ], //<Widget>[]
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0),
                      child: Row(
                        children: <Widget>[
                          //SizedBox
                          Text(
                            AppLocalizations.of(context)!.curtains,
                            style: const TextStyle(fontSize: 17.0),
                          ), //Text
                          Checkbox(
                              value: curtains,
                              onChanged: (value) {
                                setState(() {
                                  curtains = value;
                                });
                              }), //Checkbox
                        ], //<Widget>[]
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ButtonWithoutImage(
              text: AppLocalizations.of(context)!.addRoom,
              pressed: () {
                setState(() {
                  roomNumberController.text.isNotEmpty ?
                  roomNumberValidate = true:   roomNumberValidate = false;
                  roomTypeController.text.isNotEmpty ?
                  roomTypeValidate = true:   roomTypeValidate = false;
                  bedNumberController.text.isNotEmpty ?
                  bedNumberValidate = true:   bedNumberValidate = false;
                  roomPriceController.text.isNotEmpty ?
                  roomPriceValidate = true:   roomPriceValidate = false;
                });
                if(roomNumberValidate && roomTypeValidate && bedNumberValidate && roomPriceValidate){
                  final CollectionReference postsRef =
                  FirebaseFirestore.instance.collection('rooms');
                  var postID = 'room${roomNumberController.text}';
                  DocumentReference ref = postsRef.doc(postID);
                  ref.set({
                    'hotelName': hotelDropdownValue,
                    'roomNumber': roomNumberController.text,
                    'roomType': roomTypeController.text,
                    'bedNumber': int.parse(bedNumberController.text),
                    'bathroomType': finBath,
                    'roomPrice': int.parse(roomPriceController.text),
                    'roomStatus': 'Clean',
                    'reservationState': false,
                    'tv': tv,
                    'fridge': fridge,
                    'washingMachine': washingMachine,
                    'kettle': kettle,
                    'coffeeMachine': coffeeMachine,
                    'curtains': curtains,
                  });
                  Navigator.pop(context);
                }

              },
            ),
            const SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }
}
