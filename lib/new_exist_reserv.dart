import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/add_data.dart';
import 'package:hotel_managmenet/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'reusable_component.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/services.dart';

class NewExistReserveScreen extends StatefulWidget {
  final String hotelName;
  final String roomNumber;
  final DateTime startDate;
  final DateTime endDate;
  final int amountPaid;

  const NewExistReserveScreen(
      {Key? key,
      required this.hotelName,
      required this.roomNumber,
      required this.startDate, required this.amountPaid, required this.endDate})
      : super(key: key);

  @override
  State<NewExistReserveScreen> createState() => _NewExistReserveScreenState();
}

class _NewExistReserveScreenState extends State<NewExistReserveScreen> {
  final clientNameController = TextEditingController();
  final nationalityController = TextEditingController();
  final clientNationalIdController = TextEditingController();
  final clientNumberController = TextEditingController();
  bool clientNameValidate = true;
  bool nationalityValidate = true;
  bool clientNationalIdValidate = true;
  bool clientNumberValidate = true;

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
  bool comp = false;
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
      comp = true;
    } else {
      resp = await StoreData().saveData(
          file: _image!,
          clientName: clientNameController.text,
          clientNationalId: clientNationalIdController.text);
      comp = true;
    }
  }

  int? reservationNumber;
  Future<void> getReservationNumber() async {
    reservationNumber = await FirebaseFirestore.instance
        .collection('hotels')
        .doc('hotel-${widget.hotelName}')
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

  Future<void> updateReservationNumber() async {
    await FirebaseFirestore.instance.collection("hotels").get().then(
      (querySnapshot) {
        FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-${widget.hotelName}')
            .update({'reservations': reservationNumber});
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
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: DropdownButtonFormField(
                style: const TextStyle(
                  color: Color(0xFF176B87),
                ),
                value: widget.hotelName,
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
                items: [
                  DropdownMenuItem(
                    value: widget.hotelName,
                    child: Text(
                        "${AppLocalizations.of(context)!.hotelName}: ${widget.hotelName}"),
                  ),
                ],
                onChanged: null,
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
              padding:
                  const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: DropdownButtonFormField(
                style: const TextStyle(
                  color: Color(0xFF176B87),
                ),
                value: widget.roomNumber,
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
                items: [
                  DropdownMenuItem(
                    value: widget.roomNumber,
                    child: Text(
                        "${AppLocalizations.of(context)!.roomNumber}:  ${widget.roomNumber}"),
                  ),
                ],
                onChanged: null,
              ),
            ),
            ButtonWithoutImage(
              text: AppLocalizations.of(context)!.addReservation,
              pressed: () async {
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
                  comp = false;
                });
                if (clientNameValidate &&
                    nationalityValidate &&
                    clientNumberValidate &&
                    clientNationalIdValidate) {
                  if (!comp) {
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

                  await getReservationNumber();
                  await getClientNumber();

                  final CollectionReference postsRef =
                  FirebaseFirestore.instance
                      .collection('reservations');

                  var postID =
                      'reserve-${clientNameController.text}';

                  DocumentReference ref =
                  postsRef.doc(postID);

                  ref.set({
                    'reservationNumber': reservationNumber,
                    'amountPaid':widget.amountPaid,
                    'numberOfTheClient': numberOfTheClient,
                    'clientName': clientNameController.text,
                    'nationality': nationalityController.text,
                    'clientNumber': int.parse(clientNumberController.text),
                    'clientNationalId': clientNationalIdController.text,
                    'hotelName': widget.hotelName,
                    'roomNumber': widget.roomNumber,
                    'startDate': widget.startDate,
                    'endDate':widget.endDate,
                    'imageLink': resp,
                    'clientRate': AppLocalizations.of(context)!.notDetermined,
                    'bus': false,
                    'flight': false,
                    'huda': false,
                    'idBracelet': false,
                  });

                  await updateClientNumber();
                  await updateReservationNumber();
                  setState(() {
                    Navigator.pop(context);
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
