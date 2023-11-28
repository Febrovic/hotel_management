import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:hotel_managmenet/add_data.dart';
import 'package:hotel_managmenet/pdf_perview.dart';
import 'package:hotel_managmenet/reusable_component.dart';
import 'package:hotel_managmenet/specificRoomClients.dart';
import 'package:image_picker/image_picker.dart';

TextStyle onCardContent =
    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
TextStyle greenOnCardContent =
    const TextStyle(color: Colors.green, fontWeight: FontWeight.bold);
TextStyle redOnCardContent =
    const TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
TextStyle orangeOnCardContent =
    const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold);

class InfoCard extends StatelessWidget {
  final Widget child;

  const InfoCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: Material(
        elevation: 10.0,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color(0xFF57375D),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: child,
          ),
        ),
      ),
    );
  }
}

class ReservationInfoCard extends StatelessWidget {
  ReservationInfoCard({
    super.key,
    required this.clientName,
    required this.clientNumber,
    required this.clientNationalId,
    required this.hotelName,
    required this.roomNumber,
    required this.startDate,
    required this.endDate,
    required this.reservationNumber,
    required this.amountPaid,
    required this.userType,
    required this.nationality,
  });

  final int reservationNumber;
  final String clientName;
  final int clientNumber;
  final String nationality;
  final String clientNationalId;
  final String hotelName;
  final String roomNumber;
  final DateTime startDate;
  final DateTime endDate;
  final int amountPaid;
  final int? userType;
  int cost = 0;



  int bedNumber = 0;
  Future<void> getBedNumber() async {
    bedNumber = await FirebaseFirestore.instance
        .collection('rooms')
        .doc('room$roomNumber')
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
            .doc('hotel-$hotelName')
            .get()
            .then((value) {
          return value.data()?['totalIncome'];
        });
        totalRest = await FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-$hotelName')
            .get()
            .then((value) {
          return value.data()?['totalRest'];
        });

        var total = totalIncome! + amountPaid;
        FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-$hotelName')
            .update({'totalIncome': total});

        int amountTotal = (cost * (endDate.difference(startDate).inDays));
        int amountRest = amountTotal - amountPaid;

        var restTotal = totalRest! + amountRest;

        FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-$hotelName')
            .update({'totalRest': restTotal});
      },
    );
  }

  Future<void> getRoomsPrice() async {
    cost = await FirebaseFirestore.instance
        .collection('rooms')
        .doc('room$roomNumber')
        .get()
        .then((value) {
      return value.data()?['roomPrice']; // Access your after your get the data
    });
  }

  @override
  Widget build(BuildContext context) {
    getRoomsPrice();
    getBedNumber();
    var totalDays = endDate.difference(startDate).inDays;
    var restDays = endDate.difference(DateTime.now()).inDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Center(
            child: Container(
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: const Color(0xFF176B87),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.reservationNumber} : ',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    reservationNumber.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${AppLocalizations.of(context)!.clientName} : $clientName',
              style: onCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.clientNumber} : $clientNumber',
              style: onCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.clientNationalId} : $clientNationalId',
              style: onCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.hotelName} : $hotelName',
              style: onCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.roomNumber} : $roomNumber',
              style: onCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.startDate} : ${startDate.year.toString()}/${startDate.month.toString()}/${startDate.day.toString()}',
              style: onCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.endDate} : ${endDate.year.toString()}/${endDate.month.toString()}/${endDate.day.toString()}',
              style: onCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.totalDays} : $totalDays',
              style: onCardContent,
            ),
            FutureBuilder(
              future: getRoomsPrice(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                int amountTotal = (cost * totalDays);
                int amountRest = amountTotal - amountPaid;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.amountTotal} : $amountTotal',
                      style: onCardContent,
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.amountPaid} : $amountPaid',
                      style: greenOnCardContent,
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.amountRest} : $amountRest',
                      style: redOnCardContent,
                    ),
                  ],
                );
              },
            ),
            Text(
              restDays < totalDays
                  ? restDays > 0
                      ? '${AppLocalizations.of(context)!.restDays} : $restDays'
                      : '${AppLocalizations.of(context)!.restDays} : 0'
                  : '${AppLocalizations.of(context)!.restDays} : $totalDays',
              style: onCardContent,
            ),

            Row(
              children: [
                Expanded(
                  child: EditButton(
                    id: 'reserve-$clientName',
                    collectionName: 'reservations',
                    amountPaid: amountPaid,
                    totalAmount:
                        (cost * (endDate.difference(startDate).inDays)),
                    hotelName: hotelName,
                    clientName: clientName,
                  ),
                ),
                userType == 1
                    ? Expanded(
                        child: DeleteButton(
                          id: 'reserve-$clientName',
                          collectionName: 'reservations',
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            ShowClientButton(pressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SpecificRoomClients(hotelName: hotelName, roomNumber: roomNumber,userType: userType!, startDate: DateTime.now(),bedNumber: bedNumber, endDate: endDate, amountPaid: amountPaid,)));
            },),
            FutureBuilder(
              future: getRoomsPrice(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                return PrintButton(
                  hotelName: hotelName,
                  clientName: clientName,
                  clientNationalId: clientNationalId,
                  clientNumber: clientNumber,
                  roomNumber: roomNumber,
                  startDate: startDate,
                  endDate: endDate,
                  amountPaid: amountPaid,
                  amountRest: cost * totalDays - amountPaid,
                  amountTotal: cost * totalDays,
                  nationality: nationality,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class EmployeeInfoCard extends StatefulWidget {
  final String employeeName;
  final String employeeJobTitle;
  final String employeeTask;
  final int employeeNumber;
  final int employeeSalary;

  const EmployeeInfoCard(
      {super.key,
      required this.employeeName,
      required this.employeeJobTitle,
      required this.employeeTask,
      required this.employeeNumber,
      required this.employeeSalary});

  @override
  State<EmployeeInfoCard> createState() => _EmployeeInfoCardState();
}

class _EmployeeInfoCardState extends State<EmployeeInfoCard> {
  bool showImage = false;

  String? imageUrl;

  Future<void> getImage() async {
    imageUrl = await FirebaseFirestore.instance
        .collection('employees')
        .doc('employee-${widget.employeeName}')
        .get()
        .then((value) {
      return value.data()?['imageLink']; // Access your after your get the data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${AppLocalizations.of(context)!.employeeName} : ${widget.employeeName}',
              style: onCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.employeeNumber} : ${widget.employeeNumber.toString()}',
              style: onCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.employeeTitleJob} : ${widget.employeeJobTitle}',
              style: onCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.employeeTask} : ${widget.employeeTask}',
              style: onCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.employeeSalary} : ${widget.employeeSalary.toString()}',
              style: onCardContent,
            ),
            DeleteButton(
              id: 'employee-${widget.employeeName}',
              collectionName: 'employees',
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: const Color(0xFF176B87),
              ),
              child: MaterialButton(
                onPressed: () async {
                  await getImage();
                  setState(() {
                    showImage = !showImage;
                  });
                },
                child: Text(
                  AppLocalizations.of(context)!.employeeImage,
                  style: onCardContent,
                ),
              ),
            ),
            showImage
                ? Center(
                    child: Column(
                      children: [
                        Image.network(imageUrl!),
                      ],
                    ),
                  )
                : const SizedBox(
                    height: 0,
                  ),
          ],
        ),
      ],
    );
  }
}

class RoomInfoCard extends StatelessWidget {
  const RoomInfoCard({
    super.key,
    required this.roomNumber,
    required this.roomStatus,
    required this.bedNumber,
    required this.tv,
    required this.fridge,
    required this.washingMachine,
    required this.kettle,
    required this.coffeeMachine,
    required this.curtains,
    required this.hotelName,
    required this.roomType,
    required this.roomPrice,
    required this.bathroomType,
    required this.reservationState,
    required this.userType,
  });

  final String hotelName;
  final String roomNumber;
  final String roomType;
  final String roomStatus;
  final int bedNumber;
  final String bathroomType;
  final bool reservationState;
  final int roomPrice;
  final bool tv;
  final bool fridge;
  final bool washingMachine;
  final bool kettle;
  final bool coffeeMachine;
  final bool curtains;
  final int? userType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: userType == 1
          ? [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.hotelName} : $hotelName',
                        style: onCardContent,
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.roomNumber} : $roomNumber',
                        style: onCardContent,
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.roomType} : $roomType',
                        style: onCardContent,
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.bedNumber} : ${bedNumber.toString()}',
                        style: onCardContent,
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.bathroomType} : ${bathroomType.toString()}',
                        style: onCardContent,
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF6D5D6E),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.roomPrice} ',
                            style: onCardContent,
                          ),
                          Text(
                            '${'SR'}${roomPrice.toString()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.tv} : ',
                        style: onCardContent,
                      ),
                      tv
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.coffeeMachine} : ',
                        style: onCardContent,
                      ),
                      coffeeMachine
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.fridge} : ',
                        style: onCardContent,
                      ),
                      fridge
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.washingMachine} : ',
                        style: onCardContent,
                      ),
                      washingMachine
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.kettle} : ',
                        style: onCardContent,
                      ),
                      kettle
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.curtains} : ',
                        style: onCardContent,
                      ),
                      curtains
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.roomStatus} : $roomStatus ',
                    style: onCardContent,
                  ),
                  reservationState
                      ? Row(
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.reservationState} : ',
                              style: onCardContent,
                            ),
                            Text(
                              AppLocalizations.of(context)!.reserved,
                              style: redOnCardContent,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.reservationState} : ',
                              style: onCardContent,
                            ),
                            Text(
                              AppLocalizations.of(context)!.notReserved,
                              style: greenOnCardContent,
                            ),
                          ],
                        ),
                ],
              ),
              EditRoomStateButton(
                id: 'room$roomNumber',
                collectionName: 'rooms',
              ),
              DeleteButton(
                id: 'room$roomNumber',
                collectionName: 'rooms',
              ),
            ]
          : [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.hotelName} : $hotelName',
                        style: onCardContent,
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.roomNumber} : $roomNumber',
                        style: onCardContent,
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.roomType} : $roomType',
                        style: onCardContent,
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.bedNumber} : ${bedNumber.toString()}',
                        style: onCardContent,
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.bathroomType} : ${bathroomType.toString()}',
                        style: onCardContent,
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF6D5D6E),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.roomPrice} ',
                            style: onCardContent,
                          ),
                          Text(
                            '${'\$'}${roomPrice.toString()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.tv} : ',
                        style: onCardContent,
                      ),
                      tv
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.coffeeMachine} : ',
                        style: onCardContent,
                      ),
                      coffeeMachine
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.fridge} : ',
                        style: onCardContent,
                      ),
                      fridge
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.washingMachine} : ',
                        style: onCardContent,
                      ),
                      washingMachine
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.kettle} : ',
                        style: onCardContent,
                      ),
                      kettle
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.curtains} : ',
                        style: onCardContent,
                      ),
                      curtains
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.roomStatus} : $roomStatus ',
                    style: onCardContent,
                  ),
                  reservationState
                      ? Row(
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.reservationState} : ',
                              style: onCardContent,
                            ),
                            Text(
                              AppLocalizations.of(context)!.reserved,
                              style: redOnCardContent,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.reservationState} : ',
                              style: onCardContent,
                            ),
                            Text(
                              AppLocalizations.of(context)!.notReserved,
                              style: greenOnCardContent,
                            ),
                          ],
                        ),
                ],
              ),
            ],
    );
  }
}

class RoomReportInfoCard extends StatelessWidget {
  const RoomReportInfoCard({
    super.key,
    required this.roomNumber,
    required this.bedNumber,
    required this.bathroomType,
    required this.reservationState,
    required this.selectedRadio,
    required this.clientName,
    required this.clientNationalId,
    required this.startDate,
    required this.endDate,
  });

  final String roomNumber;
  final int bedNumber;
  final String bathroomType;
  final bool reservationState;
  final int selectedRadio;
  final String clientName;
  final String clientNationalId;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.roomNumber} : $roomNumber',
                  style: onCardContent,
                ),
                Text(
                  '${AppLocalizations.of(context)!.bedNumber} : ${bedNumber.toString()}',
                  style: onCardContent,
                ),
                Text(
                  '${AppLocalizations.of(context)!.bathroomType} : ${bathroomType.toString()}',
                  style: onCardContent,
                ),
              ],
            ),
            selectedRadio == 2
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF176B87),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  AppLocalizations.of(context)!.clientInfo),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      '${AppLocalizations.of(context)!.clientName} : $clientName'),
                                  Text(
                                      '${AppLocalizations.of(context)!.clientNationalId} : $clientNationalId'),
                                  Text(
                                      '${AppLocalizations.of(context)!.startDate} : ${startDate.year.toString()}/${startDate.month.toString()}/${startDate.day.toString()}'),
                                  Text(
                                      '${AppLocalizations.of(context)!.endDate} : ${endDate.year.toString()}/${endDate.month.toString()}/${endDate.day.toString()}'),
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
                              ],
                            );
                          });
                    },
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.clientInfo,
                          style: onCardContent,
                        ),
                        const Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ],
    );
  }
}

class ClientInfoCard extends StatefulWidget {
  final String clientName;
  final int clientNumber;
  final String clientNationalId;
  final String nationality;
  final int numberOfTheClient;
  final DateTime startDate;
  final String clientRate;
  final int userType;
  final bool bus;
  final bool flight;
  final bool idBracelet;
  final bool huda;

  const ClientInfoCard({
    super.key,
    required this.clientName,
    required this.clientNumber,
    required this.clientNationalId,
    required this.nationality,
    required this.numberOfTheClient,
    required this.startDate,
    required this.clientRate,
    required this.userType,
    required this.bus,
    required this.flight,
    required this.idBracelet,
    required this.huda,
  });

  @override
  State<ClientInfoCard> createState() => _ClientInfoCardState();
}

class _ClientInfoCardState extends State<ClientInfoCard> {
  bool bus = false;
  bool flight = false;
  bool idBracelet = false;
  bool huda = false;

  bool validate = true;

  final clientRateController = TextEditingController();

  bool showImage = false;
  String? imageUrl;
  Future<void> getImage() async {
    imageUrl = await FirebaseFirestore.instance
        .collection('reservations')
        .doc('reserve-${widget.clientName}')
        .get()
        .then((value) {
      return value.data()?['imageLink']; // Access your after your get the data
    });
  }

  Future<void> updateClientRate() async {
    await FirebaseFirestore.instance.collection("reservations").get().then(
      (querySnapshot) {
        FirebaseFirestore.instance
            .collection('reservations')
            .doc('reserve-${widget.clientName}')
            .update({'clientRate': clientRateController.text});
      },
    );
  }

  Future<void> updateAdditionalServices() async {
    await FirebaseFirestore.instance.collection("reservations").get().then(
      (querySnapshot) {
        FirebaseFirestore.instance
            .collection('reservations')
            .doc('reserve-${widget.clientName}')
            .update({
          'bus': bus ? true : false,
          'idBracelet': idBracelet ? true : false,
          'huda': huda ? true : false,
          'flight': flight ? true : false,
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Center(
            child: Container(
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: const Color(0xFF176B87),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.numberOfTheClient} : ',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.numberOfTheClient.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Text(
          '${AppLocalizations.of(context)!.clientName} : ${widget.clientName}',
          style: onCardContent,
        ),
        Text(
          '${AppLocalizations.of(context)!.clientNumber} :${widget.clientNumber}',
          style: onCardContent,
        ),
        Text(
          '${AppLocalizations.of(context)!.clientNationalId} : ${widget.clientNationalId}',
          style: onCardContent,
        ),
        Text(
          '${AppLocalizations.of(context)!.nationality} : ${widget.nationality}',
          style: onCardContent,
        ),
        Text(
          '${AppLocalizations.of(context)!.dateOfRegistration} : ${widget.startDate.year.toString()}/${widget.startDate.month.toString()}/${widget.startDate.day.toString()}',
          style: onCardContent,
        ),
        // Container(
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(5.0),
        //     color: const Color(0xFF176B87),
        //   ),
        //   child: MaterialButton(
        //     onPressed: () {
        //       bus = widget.bus;
        //       flight = widget.flight;
        //       huda = widget.huda;
        //       idBracelet = widget.idBracelet;
        //
        //       showDialog(
        //           context: context,
        //           builder: (BuildContext context) {
        //             return StatefulBuilder(
        //               builder: (BuildContext context,
        //                   void Function(void Function()) setState) {
        //                 return AlertDialog(
        //                   title: Text(
        //                       AppLocalizations.of(context)!.additionalServices),
        //                   content: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                     children: [
        //                       Column(
        //                         crossAxisAlignment: CrossAxisAlignment.end,
        //                         mainAxisSize: MainAxisSize.min,
        //                         children: [
        //                           Row(
        //                             children: <Widget>[
        //                               //SizedBox
        //                               Text(
        //                                 AppLocalizations.of(context)!.bus,
        //                                 style: const TextStyle(fontSize: 17.0),
        //                               ), //Text
        //                               Checkbox(
        //                                   value: bus,
        //                                   onChanged: (value) {
        //                                     setState(() {
        //                                       bus = value!;
        //                                     });
        //                                   }), //Checkbox
        //                             ], //<Widget>[]
        //                           ),
        //                           Row(
        //                             children: <Widget>[
        //                               //SizedBox
        //                               Text(
        //                                 AppLocalizations.of(context)!
        //                                     .idBracelet,
        //                                 style: const TextStyle(fontSize: 17.0),
        //                               ), //Text
        //                               Checkbox(
        //                                   value: idBracelet,
        //                                   onChanged: (value) {
        //                                     setState(() {
        //                                       idBracelet = value!;
        //                                     });
        //                                   }), //Checkbox
        //                             ], //<Widget>[]
        //                           ),
        //                         ],
        //                       ),
        //                       Column(
        //                         crossAxisAlignment: CrossAxisAlignment.end,
        //                         mainAxisSize: MainAxisSize.min,
        //                         children: [
        //                           Row(
        //                             children: <Widget>[
        //                               //SizedBox
        //                               Text(
        //                                 AppLocalizations.of(context)!.flight,
        //                                 style: const TextStyle(fontSize: 17.0),
        //                               ), //Text
        //                               Checkbox(
        //                                   value: flight,
        //                                   onChanged: (value) {
        //                                     setState(() {
        //                                       flight = value!;
        //                                     });
        //                                   }), //Checkbox
        //                             ], //<Widget>[]
        //                           ),
        //                           Row(
        //                             children: <Widget>[
        //                               //SizedBox
        //                               Text(
        //                                 AppLocalizations.of(context)!.huda,
        //                                 style: const TextStyle(fontSize: 17.0),
        //                               ), //Text
        //                               Checkbox(
        //                                   value: huda,
        //                                   onChanged: (value) {
        //                                     setState(() {
        //                                       huda = value!;
        //                                     });
        //                                   }), //Checkbox
        //                             ], //<Widget>[]
        //                           ),
        //                         ],
        //                       ),
        //                     ],
        //                   ),
        //                   actions: [
        //                     MaterialButton(
        //                       onPressed: () {
        //                         Navigator.pop(context);
        //                       },
        //                       child:
        //                           Text(AppLocalizations.of(context)!.dismiss),
        //                     ),
        //                     MaterialButton(
        //                       onPressed: () {
        //                         updateAdditionalServices();
        //                         Navigator.pop(context);
        //                       },
        //                       child: Text(AppLocalizations.of(context)!.save),
        //                     ),
        //                   ],
        //                 );
        //               },
        //             );
        //           });
        //     },
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Column(
        //           crossAxisAlignment: CrossAxisAlignment.end,
        //           children: [
        //             Row(
        //               children: [
        //                 Text(
        //                   '${AppLocalizations.of(context)!.bus} : ',
        //                   style: onCardContent,
        //                 ),
        //                 widget.bus
        //                     ? const Icon(
        //                   Icons.check,
        //                   color: Colors.green,
        //                 )
        //                     : const Icon(
        //                   Icons.close,
        //                   color: Colors.red,
        //                 ),
        //               ],
        //             ),
        //             Row(
        //               children: [
        //                 Text(
        //                   '${AppLocalizations.of(context)!.idBracelet} : ',
        //                   style: onCardContent,
        //                 ),
        //                 widget.idBracelet
        //                     ? const Icon(
        //                   Icons.check,
        //                   color: Colors.green,
        //                 )
        //                     : const Icon(
        //                   Icons.close,
        //                   color: Colors.red,
        //                 ),
        //               ],
        //             ),
        //           ],
        //         ),
        //         Column(
        //           crossAxisAlignment: CrossAxisAlignment.end,
        //           children: [
        //             Row(
        //               children: [
        //                 Text(
        //                   '${AppLocalizations.of(context)!.flight} : ',
        //                   style: onCardContent,
        //                 ),
        //                 widget.flight
        //                     ? const Icon(
        //                   Icons.check,
        //                   color: Colors.green,
        //                 )
        //                     : const Icon(
        //                   Icons.close,
        //                   color: Colors.red,
        //                 ),
        //               ],
        //             ),
        //             Row(
        //               children: [
        //                 Text(
        //                   '${AppLocalizations.of(context)!.huda} : ',
        //                   style: onCardContent,
        //                 ),
        //                 widget.huda
        //                     ? const Icon(
        //                   Icons.check,
        //                   color: Colors.green,
        //                 )
        //                     : const Icon(
        //                   Icons.close,
        //                   color: Colors.red,
        //                 ),
        //               ],
        //             ),
        //           ],
        //         ),
        //
        //       ],
        //     ),
        //   ),
        // ),
        const SizedBox(
          height: 10,
        ),
        widget.userType == 1
            ? Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: const Color(0xFF176B87),
                ),
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                                Text(AppLocalizations.of(context)!.clientRate),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(AppLocalizations.of(context)!.clientRate),
                                TextFieldCustom(
                                  labelText:
                                      AppLocalizations.of(context)!.clientRate,
                                  textInputType: TextInputType.text,
                                  controller: clientRateController,
                                  validate: validate,
                                ),
                              ],
                            ),
                            actions: [
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.dismiss),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    clientRateController.text.isNotEmpty
                                        ? validate = true
                                        : validate = false;
                                  });
                                  if (validate == true) {
                                    updateClientRate();
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(AppLocalizations.of(context)!.save),
                              ),
                            ],
                          );
                        });
                  },
                  child: Text(
                    '${AppLocalizations.of(context)!.clientRate} : ${widget.clientRate}',
                    style: onCardContent,
                  ),
                ),
              )
            : Text(
                '${AppLocalizations.of(context)!.clientRate} : ${widget.clientRate}',
                style: onCardContent,
              ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: const Color(0xFF176B87),
          ),
          child: MaterialButton(
            onPressed: () async {
              await getImage();
              setState(() {
                showImage = !showImage;
              });
            },
            child: Text(
              AppLocalizations.of(context)!.idImage,
              style: onCardContent,
            ),
          ),
        ),
        showImage
            ? Center(
                child: Column(
                  children: [
                    Image.network(imageUrl!),
                  ],
                ),
              )
            : const SizedBox(
                height: 0,
              ),
      ],
    );
  }
}

class BusInfoCard extends StatefulWidget {
  final String clientName;
  final int clientNumber;
  final String clientNationalId;
  final DateTime startDate;
  final String hotelName;
  final String roomNumber;
  const BusInfoCard({Key? key, required this.clientName, required this.clientNumber, required this.clientNationalId, required this.startDate, required this.hotelName, required this.roomNumber}) : super(key: key);

  @override
  State<BusInfoCard> createState() => _BusInfoCardState();
}

class _BusInfoCardState extends State<BusInfoCard> {

  bool bus = false;
  bool flight = false;
  bool idBracelet = false;
  bool huda = false;

  bool validate = true;

  final serviceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${AppLocalizations.of(context)!.clientName} : ${widget.clientName}',
              style: onCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.clientNumber} : ${widget.clientNumber}',
              style: onCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.clientNationalId} : ${widget.clientNationalId}',
              style: onCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.hotelName} : ${widget.hotelName}',
              style: onCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.roomNumber} : ${widget.roomNumber}',
              style: onCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.startDate} : ${widget.startDate.year.toString()}/${widget.startDate.month.toString()}/${widget.startDate.day.toString()}',
              style: onCardContent,
            ),
          ],
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: const Color(0xFF176B87),
          ),
          child: MaterialButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title:
                      Text(AppLocalizations.of(context)!.addToThisService),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFieldCustom(
                            labelText:
                            AppLocalizations.of(context)!.addAmount,
                            textInputType: TextInputType.text,
                            controller: serviceController,
                            validate: validate,
                          ),
                        ],
                      ),
                      actions: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child:
                          Text(AppLocalizations.of(context)!.dismiss),
                        ),
                        MaterialButton(
                          onPressed: () {
                            setState(() {
                              serviceController.text.isNotEmpty
                                  ? validate = true
                                  : validate = false;
                            });
                            if (validate == true) {
                              Navigator.pop(context);
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.save),
                        ),
                      ],
                    );
                  });
            },
            child: Text(
              AppLocalizations.of(context)!.addToThisService,
              style: onCardContent,
            ),
          ),
        ),
      ],
    );
  }
}

class RoomReportsInfoCard extends StatelessWidget {
  int? roomsCount;
  int? emptyRoomsCount;
  int? reservedRoomsCount;
  int? maintenanceRoomsCount;
  int? checkOutTodayCount;
  int? checkInTodayCount;
  int? totalIncome;
  int? totalOutcome;
  int? totalRestIncome;
  int netProfit = 0;
  final String hotelName;

  RoomReportsInfoCard({super.key, required this.hotelName});

  Future<void> roomsInfo() async {
    await FirebaseFirestore.instance.collection("rooms").get().then(
      (querySnapshot) async {
        roomsCount = 0;
        emptyRoomsCount = 0;
        reservedRoomsCount = 0;
        maintenanceRoomsCount = 0;
        checkOutTodayCount = 0;
        checkInTodayCount = 0;
        for (var docSnapshot in querySnapshot.docs) {
          if (hotelName == docSnapshot.data()['hotelName']) {
            roomsCount = roomsCount! + 1;

            if (docSnapshot.data()['reservationState'] == false) {
              emptyRoomsCount = emptyRoomsCount! + 1;
            }

            if (docSnapshot.data()['reservationState'] == true) {
              reservedRoomsCount = reservedRoomsCount! + 1;
            }

            if (docSnapshot.data()['roomStatus'] == 'صيانة') {
              maintenanceRoomsCount = maintenanceRoomsCount! + 1;
            }
          }
        }
      },
    );

    await FirebaseFirestore.instance.collection("reservations").get().then(
      (querySnapshot) async {
        checkOutTodayCount = 0;
        checkInTodayCount = 0;
        for (var docSnapshot in querySnapshot.docs) {
          if (hotelName == docSnapshot.data()['hotelName']) {
            if ((DateTime.now()
                    .add(
                      const Duration(
                        days: -1,
                      ),
                    )
                    .isBefore(docSnapshot.data()['startDate'].toDate())) &&
                (DateTime.now()
                    .add(
                      const Duration(
                        days: 1,
                      ),
                    )
                    .isAfter(docSnapshot.data()['startDate'].toDate()))) {
              checkInTodayCount = checkInTodayCount! + 1;
            }

            if ((DateTime.now()
                    .add(
                      const Duration(
                        days: -1,
                      ),
                    )
                    .isBefore(docSnapshot.data()['endDate'].toDate())) &&
                (DateTime.now()
                    .add(
                      const Duration(
                        days: 1,
                      ),
                    )
                    .isAfter(docSnapshot.data()['endDate'].toDate()))) {
              checkOutTodayCount = checkOutTodayCount! + 1;
            }
          }
        }
      },
    );
  }

  Future<void> inOutcome() async {
    await FirebaseFirestore.instance.collection("hotels").get().then(
      (querySnapshot) async {
        var flag = 0;
        for (var docSnapshot in querySnapshot.docs) {
          if (hotelName == docSnapshot.data()['hotelName']) {
            totalIncome = await FirebaseFirestore.instance
                .collection('hotels')
                .doc('hotel-$hotelName')
                .get()
                .then((value) {
              return value.data()?[
                  'totalIncome']; // Access your after your get the data
            });
            totalRestIncome = await FirebaseFirestore.instance
                .collection('hotels')
                .doc('hotel-$hotelName')
                .get()
                .then((value) {
              return value
                  .data()?['totalRest']; // Access your after your get the data
            });
            totalOutcome = await FirebaseFirestore.instance
                .collection('hotels')
                .doc('hotel-$hotelName')
                .get()
                .then((value) {
              return value.data()?[
                  'totalOutcome']; // Access your after your get the data
            });
          } else {
            flag = 1;
          }
        }
        if (flag < 0) {
          totalIncome = 0;
          totalRestIncome = 0;
          totalOutcome = 0;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
          future: roomsInfo(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (roomsCount != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.roomsNumber}: $roomsCount',
                    style: onCardContent,
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.availableRooms}: $emptyRoomsCount',
                    style: onCardContent,
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.reservedRooms}: $reservedRoomsCount',
                    style: onCardContent,
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.maintenanceRoom}: $maintenanceRoomsCount',
                    style: onCardContent,
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.checkInToday}: $checkInTodayCount',
                    style: onCardContent,
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.checkOutToday}: $checkOutTodayCount',
                    style: onCardContent,
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        FutureBuilder(
          future: inOutcome(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (totalIncome != null &&
                totalOutcome != null &&
                totalRestIncome != null) {
              netProfit = ((totalIncome! + totalRestIncome!) - totalOutcome!);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.totalIncome}: $totalIncome',
                    style: greenOnCardContent,
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.totalRestIncome}: $totalRestIncome',
                    style: orangeOnCardContent,
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.totalOutcome}: $totalOutcome',
                    style: redOnCardContent,
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.netProfit}: $netProfit',
                    style:
                        netProfit > 0 ? greenOnCardContent : redOnCardContent,
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        ButtonWithoutImage(
            text: AppLocalizations.of(context)!.printHotelReport,
            pressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HotelPdfPrev(
                            roomNumber: roomsCount.toString(),
                            roomAvailable: emptyRoomsCount.toString(),
                            roomReserved: reservedRoomsCount.toString(),
                            maintenanceRoom: maintenanceRoomsCount.toString(),
                            checkOutTodayCount: checkOutTodayCount.toString(),
                            checkInTodayCount: checkInTodayCount.toString(),
                            totalIncome: totalIncome.toString(),
                            totalRestIncome: totalRestIncome.toString(),
                            totalOutcome: totalOutcome.toString(),
                            netProfit: netProfit.toString(),
                            hotelName: hotelName,
                          )));
            }),
      ],
    );
  }
}

class InOutcomeCard extends StatelessWidget {
  InOutcomeCard({super.key, required this.hotelName});
  int totalIncome = 0;
  int totalOutcome = 0;
  int totalRestIncome = 0;
  final String hotelName;

  Future<void> inOutcome() async {
    await FirebaseFirestore.instance.collection("hotels").get().then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          if (hotelName == docSnapshot.data()['hotelName']) {
            totalIncome = await FirebaseFirestore.instance
                .collection('hotels')
                .doc('hotel-$hotelName')
                .get()
                .then((value) {
              return value.data()?[
                  'totalIncome']; // Access your after your get the data
            });
            totalRestIncome = await FirebaseFirestore.instance
                .collection('hotels')
                .doc('hotel-$hotelName')
                .get()
                .then((value) {
              return value
                  .data()?['totalRest']; // Access your after your get the data
            });
            totalOutcome = await FirebaseFirestore.instance
                .collection('hotels')
                .doc('hotel-$hotelName')
                .get()
                .then((value) {
              return value.data()?[
                  'totalOutcome']; // Access your after your get the data
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: inOutcome(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        int netProfit = ((totalIncome + totalRestIncome) - totalOutcome);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppLocalizations.of(context)!.totalIncome}: $totalIncome',
              style: greenOnCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.totalRestIncome}: $totalRestIncome',
              style: orangeOnCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.totalOutcome}: $totalOutcome',
              style: redOnCardContent,
            ),
            Text(
              '${AppLocalizations.of(context)!.netProfit}: $netProfit',
              style: netProfit > 0 ? greenOnCardContent : redOnCardContent,
            ),
          ],
        );
      },
    );
  }
}

class OutcomeInfoCard extends StatefulWidget {
  final String outcomeName;
  final String outcomeTo;
  final String thatAbout;
  final int amount;

  const OutcomeInfoCard(
      {super.key,
      required this.outcomeName,
      required this.outcomeTo,
      required this.thatAbout,
      required this.amount});

  @override
  State<OutcomeInfoCard> createState() => _OutcomeInfoCardState();
}

class _OutcomeInfoCardState extends State<OutcomeInfoCard> {
  Uint8List? _image;
  bool showImage = false;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
    await saveImage();
    final CollectionReference postsRef =
        FirebaseFirestore.instance.collection('outcome');

    var postID = '${widget.outcomeName}-${widget.amount}';

    DocumentReference ref = postsRef.doc(postID);

    ref.update({
      'invoiceImage': resp,
    });
  }

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
  }

  String? imageUrl;
  Future<void> getImageUrl() async {
    imageUrl = await FirebaseFirestore.instance
        .collection('outcome')
        .doc('${widget.outcomeName}-${widget.amount}')
        .get()
        .then((value) {
      return value
          .data()?['invoiceImage']; // Access your after your get the data
    });
  }

  String resp = 'no link';
  bool comp = false;
  Future<void> saveImage() async {
    resp = await StoreData().saveDataReport(
        file: _image!, outcomeName: widget.outcomeName, amount: widget.amount);
    comp = true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${AppLocalizations.of(context)!.outcomeName} : ${widget.outcomeName}',
          style: onCardContent,
        ),
        Text(
          '${AppLocalizations.of(context)!.outcomeTo} :${widget.outcomeTo}',
          style: onCardContent,
        ),
        Text(
          '${AppLocalizations.of(context)!.thatAbout} : ${widget.thatAbout}',
          style: onCardContent,
        ),
        Text(
          '${AppLocalizations.of(context)!.amount} : ${widget.amount.toString()}',
          style: onCardContent,
        ),
        PrintOutcomeButton(
            outcomeName: widget.outcomeName,
            outcomeTo: widget.outcomeTo,
            thatAbout: widget.thatAbout,
            amount: widget.amount),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF176B87)),
            onPressed: () async {
              setState(() {
                selectImage();
              });
              await getImageUrl();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.addInvoiceImage),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF176B87)),
            onPressed: () async {
              await getImageUrl();
              setState(() {
                showImage = !showImage;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.invoiceImage),
              ],
            ),
          ),
        ),
        imageUrl != null
            ? showImage
                ? Center(
                    child: Column(
                      children: [
                        Image.network(imageUrl!),
                      ],
                    ),
                  )
                : const SizedBox()
            : const SizedBox()
      ],
    );
  }
}

class UsersInfoCard extends StatelessWidget {
  final String username;
  final String password;

  const UsersInfoCard(
      {super.key, required this.username, required this.password});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)!.userName}: $username',
          style: greenOnCardContent,
        ),
        Text(
          '${AppLocalizations.of(context)!.password}: $password',
          style: orangeOnCardContent,
        ),
        Row(
          children: [
            Expanded(
              child: EditPasswordButton(
                id: 'user-$username',
                collectionName: 'users',
              ),
            ),
            Expanded(
              child: DeleteButton(
                id: 'user-$username',
                collectionName: 'users',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StakeholdersInfoCard extends StatelessWidget {
  final String stakeholderName;
  final int stakeholderAmount;

  const StakeholdersInfoCard(
      {super.key,
      required this.stakeholderName,
      required this.stakeholderAmount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)!.stakeholderName}: $stakeholderName',
          style: greenOnCardContent,
        ),
        Text(
          '${AppLocalizations.of(context)!.stakeholderAmount}: $stakeholderAmount',
          style: orangeOnCardContent,
        ),
        Row(
          children: [
            Expanded(
              child: EditStakeholderAmount(
                id: 'stakeholder-$stakeholderName',
                collectionName: 'stakeholders',
              ),
            ),
            Expanded(
              child: DeleteButton(
                id: 'stakeholder-$stakeholderName',
                collectionName: 'stakeholders',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
