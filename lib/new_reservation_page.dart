import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/add_data.dart';
import 'package:hotel_managmenet/constants.dart';
import 'package:hotel_managmenet/pdf_perview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'reusable_component.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import 'package:flutter/services.dart';

class NewReservation extends StatefulWidget {
  final int clientType;

  const NewReservation({super.key, required this.clientType});

  @override
  State<NewReservation> createState() => _NewReservationState();
}

class _NewReservationState extends State<NewReservation> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final clientNameController = TextEditingController();
  final nationalityController = TextEditingController();
  final clientNationalIdController = TextEditingController();
  final amountPaidController = TextEditingController();
  final clientNumberController = TextEditingController();
  String hotelDropdownValue = 'اسم الفندق';
  var hotels = [
    'اسم الفندق',
  ];
  bool clientNameValidate = true;
  bool nationalityValidate = true;
  bool clientNationalIdValidate = true;
  bool amountPaidValidate = true;
  bool clientNumberValidate = true;
  bool roomNumberValidate = true;
  String roomNumbersDropDownValue = ' ';
  var roomNumDropdownValue = [
    ' ',
  ];

  int bedNumber = 0;
  Future<void> getBedNumber() async {
    bedNumber = await FirebaseFirestore.instance
        .collection('rooms')
        .doc('room$roomNumbersDropDownValue')
        .get()
        .then((value) {
      return value.data()?['bedNumber']; // Access your after your get the data
    });
  }

  int? totalIncome;
  int? totalRest;
  Future<void> updateTotalIncome() async {
    await FirebaseFirestore.instance.collection("hotels").get().then(
      (querySnapshot) async {
        totalIncome = await FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-$hotelDropdownValue')
            .get()
            .then((value) {
          return value.data()?['totalIncome'];
        });
        totalRest = await FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-$hotelDropdownValue')
            .get()
            .then((value) {
          return value.data()?['totalRest'];
        });

        var total = totalIncome! + int.parse(amountPaidController.text);
        FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-$hotelDropdownValue')
            .update({'totalIncome': total});

        int amountTotal = (cost * totalDays!);
        int amountRest = amountTotal - int.parse(amountPaidController.text);

        var restTotal = totalRest! + amountRest;

        FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-$hotelDropdownValue')
            .update({'totalRest': restTotal});
      },
    );
  }

  int cost = 0;
  Future<void> getRoomsPrice() async {
    cost = await FirebaseFirestore.instance
        .collection('rooms')
        .doc('room$roomNumbersDropDownValue')
        .get()
        .then((value) {
      return value.data()?['roomPrice']; // Access your after your get the data
    });
  }

  Uint8List? _image;
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
  }

  String resp = 'no link';
  bool comp =false;
  Future<void> saveImage() async {
    if (_image == null) {
      String imageUrl = 'https://static.thenounproject.com/png/897141-200.png';
      Uint8List defaultImage =
          (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl))
              .buffer
              .asUint8List();
      resp = await StoreData().saveData(
          file: defaultImage,
          clientName: clientNameController.text,
          clientNationalId: clientNationalIdController.text);
      comp =true;
    } else {
      resp = await StoreData().saveData(
          file: _image!,
          clientName: clientNameController.text,
          clientNationalId: clientNationalIdController.text);
      comp = true;
    }
  }

  Future<void> getRoomsNumber() async {
    await FirebaseFirestore.instance.collection("rooms").get().then(
      (querySnapshot) {
        roomNumDropdownValue = [];
        for (var docSnapshot in querySnapshot.docs) {
          if (hotelDropdownValue == docSnapshot.data()['hotelName']) {
            roomNumDropdownValue
                .add(docSnapshot.data()['roomNumber'].toString());
          }
        }
        if (roomNumDropdownValue.isEmpty) {
          roomNumDropdownValue
              .add(AppLocalizations.of(context)!.noRoomAvailable);
        }
      },
    );
  }

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

  bool isReserved = false;
  Future<void> getRoomsReservation() async {
    await FirebaseFirestore.instance.collection("reservations").get().then(
      (querySnapshot) {
        DateTime endDateField =
            DateFormat('yMMMd').parse(_endDateController.text);
        DateTime startDateField =
            DateFormat('yMMMd').parse(_startDateController.text);

        for (var docSnapshot in querySnapshot.docs) {
          DateTime endDateDB = docSnapshot.data()['endDate'].toDate();
          DateTime startDateDB = docSnapshot.data()['startDate'].toDate();

          if (hotelDropdownValue == docSnapshot.data()['hotelName']) {
            if (roomNumbersDropDownValue ==
                docSnapshot.data()['roomNumber'].toString()) {
              if (startDateField
                  .isBefore(endDateDB.add(const Duration(days: 1))) &&
                  endDateField
                  .isAfter(startDateDB.add(const Duration(days: -1)))) {
                isReserved = true;
              } else {
                isReserved = false;
              }
            } else {
              isReserved = false;
            }
          } else {
            isReserved = false;
          }
        }
      },
    );
  }

  int? reservationNumber;
  Future<void> getReservationNumber() async {
    reservationNumber = await FirebaseFirestore.instance
        .collection('hotels')
        .doc('hotel-$hotelDropdownValue')
        .get()
        .then((value) {
      return value
          .data()?['reservations']; // Access your after your get the data
    });

    reservationNumber = (reservationNumber! + 1);
  }

  int? numberOfTheClient;
  Future<void> getClientNumber() async {
    final roomsRef = FirebaseFirestore.instance.collection('reservations');
    final roomsSnapshot = await roomsRef.get();
    numberOfTheClient = roomsSnapshot.size;
    numberOfTheClient = (numberOfTheClient! + 1);

    numberOfTheClient = await FirebaseFirestore.instance
        .collection('hotels')
        .doc('hotel-$hotelDropdownValue')
        .get()
        .then((value) {
      return value.data()?['clients']; // Access your after your get the data
    });
    numberOfTheClient = (numberOfTheClient! + 1);
  }

  Future<void> updateClientNumber() async {
    await FirebaseFirestore.instance.collection("hotels").get().then(
      (querySnapshot) {
        FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-$hotelDropdownValue')
            .update({'clients': numberOfTheClient});
      },
    );
  }

  Future<void> updateReservationNumber() async {
    await FirebaseFirestore.instance.collection("hotels").get().then(
      (querySnapshot) {
        FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-$hotelDropdownValue')
            .update({'reservations': reservationNumber});
      },
    );
  }

  int? totalDays;
  Future<void> getTotalDays() async {
    DateTime startDate = DateFormat('yMMMd').parse(_startDateController.text);
    DateTime endDate = DateFormat('yMMMd').parse(_endDateController.text);
    totalDays = endDate.difference(startDate).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.appBarBGColor,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.addReservation),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ButtonWithoutImage(
              text: AppLocalizations.of(context)!.identityImage,
              pressed: selectImage,
            ),
            if (_image != null)
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 150.0,
                  child: Image(
                    image: MemoryImage(_image!),
                    fit: BoxFit.cover,
                  ),
                ),
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
            TextFieldCustom(
              controller: clientNameController,
              labelText: AppLocalizations.of(context)!.clientName,
              textInputType: TextInputType.text,
              validate: clientNameValidate,
            ),
            TextFieldCustom(
              controller: nationalityController,
              labelText: AppLocalizations.of(context)!.nationality,
              textInputType: TextInputType.text,
              validate: nationalityValidate,
            ),
            TextFieldCustom(
              controller: clientNationalIdController,
              labelText: AppLocalizations.of(context)!.clientNationalId,
              textInputType: TextInputType.text,
              validate: clientNationalIdValidate,
            ),
            PhoneTextField(
              controller: clientNumberController,
              labelText: AppLocalizations.of(context)!.clientNumber,
              validate: clientNumberValidate,
            ),
            FutureBuilder(
                future: getRoomsNumber(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  var seen = <String>{};
                  List<String> uniqueList = roomNumDropdownValue
                      .where((room) => seen.add(room))
                      .toList();
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: DropdownButtonFormField(
                      style: const TextStyle(
                        color: Color(0xFF176B87),
                      ),
                      value: uniqueList[0],
                      decoration: InputDecoration(
                        errorText: roomNumberValidate
                            ? null
                            : AppLocalizations.of(context)!.validation,
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
                      items: uniqueList.map((String rooms) {
                        return DropdownMenuItem(
                          value: rooms,
                          child: Text(rooms),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          roomNumbersDropDownValue = newValue!;
                        });
                      },
                    ),
                  );
                }),
            FutureBuilder(
              future: getBedNumber(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Text(
                          '${AppLocalizations.of(context)!.bedNumber} : ${bedNumber.toString()}'),
                    ],
                  ),
                );
              },
            ),
            DateTextField(
              labelText: AppLocalizations.of(context)!.startDate,
              controller: _startDateController,
              isReserved: isReserved,
            ),
            DateTextField(
              labelText: AppLocalizations.of(context)!.endDate,
              controller: _endDateController,
              isReserved: isReserved,
            ),
            TextFieldCustom(
              controller: amountPaidController,
              labelText: AppLocalizations.of(context)!.amountPaid,
              textInputType: TextInputType.number,
              validate: amountPaidValidate,
            ),
            ButtonWithoutImage(
              text: AppLocalizations.of(context)!.addReservation,
              pressed:
                  () async {
                setState(() {
                  clientNameController.text.isEmpty
                      ? clientNameValidate = false
                      : clientNameValidate = true;
                  nationalityController.text.isEmpty
                      ? nationalityValidate = false
                      : nationalityValidate = true;
                  clientNumberController.text.isEmpty
                      ? clientNumberValidate = false
                      : clientNumberValidate = true;
                  clientNationalIdController.text.isEmpty
                      ? clientNationalIdValidate = false
                      : clientNationalIdValidate = true;
                  amountPaidController.text.isEmpty
                      ? amountPaidValidate = false
                      : amountPaidValidate = true;
                  _startDateController.text.isEmpty
                      ? isReserved = true
                      : isReserved = false;
                  _startDateController.text.isEmpty
                      ? isReserved = true
                      : isReserved = false;
                  bedNumber == 0
                      ? roomNumberValidate = false
                      : roomNumberValidate = true;
                  comp = false;
                });
                await getRoomsReservation();
                if (clientNameValidate &&
                    nationalityValidate &&
                    clientNumberValidate &&
                    clientNationalIdValidate &&
                    amountPaidValidate &&
                    !isReserved) {
                  if(!comp) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          ),
                        );
                      });
                    await saveImage();
                    Navigator.pop(context);
                  }


                    await getRoomsPrice();
                    await getTotalDays();
                    int amountTotal = (cost * totalDays!);
                    int amountRest =
                        amountTotal - int.parse(amountPaidController.text);

                    await getReservationNumber();
                    await getClientNumber();
                    final CollectionReference postsRef =
                    FirebaseFirestore.instance
                        .collection('reservations');

                  final CollectionReference postsRefRoom =
                  FirebaseFirestore.instance
                      .collection('rooms');
                    var postID =
                        'reserve-${clientNameController.text}';

                  var postIDRoom =
                      'room$roomNumbersDropDownValue';

                    DocumentReference ref =
                    postsRef.doc(postID);

                  DocumentReference refRoom =
                  postsRefRoom.doc(postIDRoom);

                    ref.set({
                      'numberOfTheClient': numberOfTheClient,
                      'reservationNumber': reservationNumber,
                      'clientName': clientNameController.text,
                      'nationality':
                      nationalityController.text,
                      'clientNumber': int.parse(
                          clientNumberController.text),
                      'clientNationalId':
                      clientNationalIdController.text,
                      'hotelName': hotelDropdownValue,
                      'roomNumber':
                      roomNumbersDropDownValue,
                      'startDate': DateFormat('yMMMd')
                          .parse(_startDateController.text),
                      'endDate': DateFormat('yMMMd')
                          .parse(_endDateController.text),
                      'amountPaid': int.parse(
                          amountPaidController.text),
                      'imageLink': resp,
                      'clientRate':
                      AppLocalizations.of(context)!
                          .notDetermined,
                    });

                  refRoom.update({
                    'clientName': clientNameController.text,
                    'clientNationalId':
                    clientNationalIdController.text,
                    'startDate': DateFormat('yMMMd')
                        .parse(_startDateController.text),
                    'endDate': DateFormat('yMMMd')
                        .parse(_endDateController.text),
                  });
                    await updateClientNumber();
                    await updateReservationNumber();
                    await updateTotalIncome();
                    setState(() {
                      isReserved
                          ? null
                          :
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(AppLocalizations.of(context)!
                                  .addReservation),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      '${AppLocalizations.of(context)!.hotelName} : $hotelDropdownValue'),
                                  Text(
                                      '${AppLocalizations.of(context)!.clientName} : ${clientNameController.text}'),
                                  Text(
                                      '${AppLocalizations.of(context)!.nationality} : ${nationalityController.text}'),
                                  Text(
                                      '${AppLocalizations.of(context)!.clientNationalId} : ${clientNationalIdController.text}'),
                                  Text(
                                      '${AppLocalizations.of(context)!.clientNumber} : ${clientNumberController.text}'),
                                  Text(
                                      '${AppLocalizations.of(context)!.roomNumber} : $roomNumbersDropDownValue'),
                                  Text(
                                      '${AppLocalizations.of(context)!.startDate} : ${_startDateController.text}'),
                                  Text(
                                      '${AppLocalizations.of(context)!.endDate} : ${_endDateController.text}'),
                                  Text(
                                      '${AppLocalizations.of(context)!.totalDays} : ${totalDays.toString()}'),
                                  Text(
                                      '${AppLocalizations.of(context)!.amountTotal} : $amountTotal'),
                                  Text(
                                      '${AppLocalizations.of(context)!.amountPaid} : ${amountPaidController.text}'),
                                  Text(
                                      '${AppLocalizations.of(context)!.amountRest} : $amountRest'),
                                ],
                              ),
                              actions: [
                                MaterialButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.dismiss),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PdfPrev(
                                              hotelName:
                                              hotelDropdownValue,
                                              clientName:
                                              clientNameController
                                                  .text,
                                              nationality:
                                              nationalityController
                                                  .text,
                                              clientId:
                                              clientNationalIdController
                                                  .text,
                                              clientNumber:
                                              clientNumberController
                                                  .text,
                                              roomNumber:
                                              roomNumbersDropDownValue,
                                              startDate:
                                              _startDateController
                                                  .text,
                                              endDate:
                                              _endDateController.text,
                                              amountPaid:
                                              amountPaidController
                                                  .text,
                                              amountRest:
                                              amountRest.toString(),
                                              amountTotal:
                                              amountTotal.toString(),
                                            )));
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.print),
                                ),
                              ],
                            );
                          });
                    });


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
