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

class AddGuestPage extends StatefulWidget {
  final String hotelName;
  final String roomNumber;
  const AddGuestPage({Key? key, required this.hotelName, required this.roomNumber}) : super(key: key);

  @override
  State<AddGuestPage> createState() => _AddGuestPageState();
}

class _AddGuestPageState extends State<AddGuestPage> {

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final clientNameController = TextEditingController();
  final nationalityController = TextEditingController();
  final clientNationalIdController = TextEditingController();
  final amountPaidController = TextEditingController();
  final clientNumberController = TextEditingController();

  bool clientNameValidate = true;
  bool nationalityValidate = true;
  bool clientNationalIdValidate = true;
  bool amountPaidValidate = true;
  bool clientNumberValidate = true;




  int? totalIncome;
  int? totalRest;
  Future<void> updateTotalIncome() async {
    await FirebaseFirestore.instance.collection("hotels").get().then(
          (querySnapshot) async {
        totalIncome = await FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-${widget.hotelName}')
            .get()
            .then((value) {
          return value.data()?['totalIncome'];
        });
        totalRest = await FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-${widget.hotelName}')
            .get()
            .then((value) {
          return value.data()?['totalRest'];
        });

        var total = totalIncome! + int.parse(amountPaidController.text);
        FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-${widget.hotelName}')
            .update({'totalIncome': total});

        int amountTotal = (cost * totalDays!);
        int amountRest = amountTotal - int.parse(amountPaidController.text);

        var restTotal = totalRest! + amountRest;

        FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-${widget.hotelName}')
            .update({'totalRest': restTotal});
      },
    );
  }

  int cost = 0;
  Future<void> getRoomsPrice() async {
    cost = await FirebaseFirestore.instance
        .collection('rooms')
        .doc('room${widget.roomNumber}')
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

  int? numberOfTheClient;
  Future<void> getClientNumber() async {
    final roomsRef = FirebaseFirestore.instance.collection('reservations');
    final roomsSnapshot = await roomsRef.get();
    numberOfTheClient = roomsSnapshot.size;
    numberOfTheClient = (numberOfTheClient! + 1);

    numberOfTheClient = await FirebaseFirestore.instance
        .collection('hotels')
        .doc('hotel-${widget.hotelName}')
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
            .doc('hotel-${widget.hotelName}')
            .update({'clients': numberOfTheClient});
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
    var hotelItem = [
      (widget.hotelName),
    ];
    var roomItem = [
      (widget.roomNumber),
    ];
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.appBarBGColor,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.addGuests),
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
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 20.0, right: 20.0),
              child: DropdownButtonFormField(

                style: const TextStyle(
                  color: Color(0xFF176B87),
                ),
                value: widget.hotelName,
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

                onChanged: null, items:  hotelItem.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 20.0, right: 20.0),
              child: DropdownButtonFormField(
                style: const TextStyle(
                  color: Color(0xFF176B87),
                ),
                value: widget.roomNumber,
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
                items: roomItem.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: null,
              ),
            ),
            DateTextField(
              labelText: AppLocalizations.of(context)!.startDate,
              controller: _startDateController,
              isReserved: false,
            ),
            DateTextField(
              labelText: AppLocalizations.of(context)!.endDate,
              controller: _endDateController,
              isReserved: false,
            ),
            TextFieldCustom(
              controller: amountPaidController,
              labelText: AppLocalizations.of(context)!.amountPaid,
              textInputType: TextInputType.number,
              validate: amountPaidValidate,
            ),
            ButtonWithoutImage(
              text: AppLocalizations.of(context)!.addReservation,
              pressed:(){
                print(widget.hotelName);
                print(widget.roomNumber);
              }
              //     () async {
              //   setState(() {
              //     clientNameController.text.isEmpty
              //         ? clientNameValidate = false
              //         : clientNameValidate = true;
              //     nationalityController.text.isEmpty
              //         ? nationalityValidate = false
              //         : nationalityValidate = true;
              //     clientNumberController.text.isEmpty
              //         ? clientNumberValidate = false
              //         : clientNumberValidate = true;
              //     clientNationalIdController.text.isEmpty
              //         ? clientNationalIdValidate = false
              //         : clientNationalIdValidate = true;
              //     amountPaidController.text.isEmpty
              //         ? amountPaidValidate = false
              //         : amountPaidValidate = true;
              //     _startDateController.text.isEmpty
              //         ? isReserved = true
              //         : isReserved = false;
              //     _startDateController.text.isEmpty
              //         ? isReserved = true
              //         : isReserved = false;
              //     comp = false;
              //   });
              //   await getRoomsReservation();
              //   if (clientNameValidate &&
              //       nationalityValidate &&
              //       clientNumberValidate &&
              //       clientNationalIdValidate &&
              //       amountPaidValidate &&
              //       !isReserved) {
              //     if(!comp) {
              //       showDialog(
              //           context: context,
              //           builder: (BuildContext context) {
              //             return const AlertDialog(
              //               content: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   CircularProgressIndicator(),
              //                 ],
              //               ),
              //             );
              //           });
              //       await saveImage();
              //       Navigator.pop(context);
              //     }
              //
              //
              //     await getRoomsPrice();
              //     await getTotalDays();
              //     int amountTotal = (cost * totalDays!);
              //     int amountRest =
              //         amountTotal - int.parse(amountPaidController.text);
              //
              //     await getReservationNumber();
              //     await getClientNumber();
              //     final CollectionReference postsRef =
              //     FirebaseFirestore.instance
              //         .collection('reservations');
              //
              //     final CollectionReference postsRefRoom =
              //     FirebaseFirestore.instance
              //         .collection('rooms');
              //     var postID =
              //         'reserve-${clientNameController.text}';
              //
              //     var postIDRoom =
              //         'room$roomNumbersDropDownValue';
              //
              //     DocumentReference ref =
              //     postsRef.doc(postID);
              //
              //     DocumentReference refRoom =
              //     postsRefRoom.doc(postIDRoom);
              //
              //     ref.set({
              //       'numberOfTheClient': numberOfTheClient,
              //       'reservationNumber': reservationNumber,
              //       'clientName': clientNameController.text,
              //       'nationality':
              //       nationalityController.text,
              //       'clientNumber': int.parse(
              //           clientNumberController.text),
              //       'clientNationalId':
              //       clientNationalIdController.text,
              //       'hotelName': hotelDropdownValue,
              //       'roomNumber':
              //       roomNumbersDropDownValue,
              //       'startDate': DateFormat('yMMMd')
              //           .parse(_startDateController.text),
              //       'endDate': DateFormat('yMMMd')
              //           .parse(_endDateController.text),
              //       'amountPaid': int.parse(
              //           amountPaidController.text),
              //       'imageLink': resp,
              //       'clientRate':
              //       AppLocalizations.of(context)!
              //           .notDetermined,
              //     });
              //
              //     refRoom.update({
              //       'clientName': clientNameController.text,
              //       'clientNationalId':
              //       clientNationalIdController.text,
              //       'startDate': DateFormat('yMMMd')
              //           .parse(_startDateController.text),
              //       'endDate': DateFormat('yMMMd')
              //           .parse(_endDateController.text),
              //     });
              //     await updateClientNumber();
              //     await updateReservationNumber();
              //     await updateTotalIncome();
              //     setState(() {
              //       isReserved
              //           ? null
              //           :
              //       showDialog(
              //           context: context,
              //           builder: (BuildContext context) {
              //             return AlertDialog(
              //               title: Text(AppLocalizations.of(context)!
              //                   .addReservation),
              //               content: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   Text(
              //                       '${AppLocalizations.of(context)!.hotelName} : $hotelDropdownValue'),
              //                   Text(
              //                       '${AppLocalizations.of(context)!.clientName} : ${clientNameController.text}'),
              //                   Text(
              //                       '${AppLocalizations.of(context)!.nationality} : ${nationalityController.text}'),
              //                   Text(
              //                       '${AppLocalizations.of(context)!.clientNationalId} : ${clientNationalIdController.text}'),
              //                   Text(
              //                       '${AppLocalizations.of(context)!.clientNumber} : ${clientNumberController.text}'),
              //                   Text(
              //                       '${AppLocalizations.of(context)!.roomNumber} : $roomNumbersDropDownValue'),
              //                   Text(
              //                       '${AppLocalizations.of(context)!.startDate} : ${_startDateController.text}'),
              //                   Text(
              //                       '${AppLocalizations.of(context)!.endDate} : ${_endDateController.text}'),
              //                   Text(
              //                       '${AppLocalizations.of(context)!.totalDays} : ${totalDays.toString()}'),
              //                   Text(
              //                       '${AppLocalizations.of(context)!.amountTotal} : $amountTotal'),
              //                   Text(
              //                       '${AppLocalizations.of(context)!.amountPaid} : ${amountPaidController.text}'),
              //                   Text(
              //                       '${AppLocalizations.of(context)!.amountRest} : $amountRest'),
              //                 ],
              //               ),
              //               actions: [
              //                 MaterialButton(
              //                   onPressed: () async {
              //                     Navigator.pop(context);
              //                   },
              //                   child: Text(
              //                       AppLocalizations.of(context)!.dismiss),
              //                 ),
              //                 MaterialButton(
              //                   onPressed: () {
              //                     Navigator.push(
              //                         context,
              //                         MaterialPageRoute(
              //                             builder: (context) => PdfPrev(
              //                               hotelName:
              //                               hotelDropdownValue,
              //                               clientName:
              //                               clientNameController
              //                                   .text,
              //                               nationality:
              //                               nationalityController
              //                                   .text,
              //                               clientId:
              //                               clientNationalIdController
              //                                   .text,
              //                               clientNumber:
              //                               clientNumberController
              //                                   .text,
              //                               roomNumber:
              //                               roomNumbersDropDownValue,
              //                               startDate:
              //                               _startDateController
              //                                   .text,
              //                               endDate:
              //                               _endDateController.text,
              //                               amountPaid:
              //                               amountPaidController
              //                                   .text,
              //                               amountRest:
              //                               amountRest.toString(),
              //                               amountTotal:
              //                               amountTotal.toString(),
              //                             )));
              //                   },
              //                   child: Text(
              //                       AppLocalizations.of(context)!.print),
              //                 ),
              //               ],
              //             );
              //           });
              //     });
              //
              //
              //   }
              // },
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
