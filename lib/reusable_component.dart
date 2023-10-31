import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_managmenet/pdf_perview.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ButtonWithoutImage extends StatelessWidget {
  final String text;
  final Function() pressed;
  const ButtonWithoutImage(
      {super.key, required this.text, required this.pressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: SizedBox(
        width: double.infinity,
        height: 60.0,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFF176B87)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          onPressed: pressed,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonWithImage extends StatelessWidget {
  final String text;
  final String imgPath;
  final Function() pressed;

  const ButtonWithImage(
      {super.key,
      required this.text,
      required this.imgPath,
      required this.pressed});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFF176B87)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          onPressed: pressed,
          child: Row(
            children: [
              SvgPicture.asset(
                imgPath,
                width: 50.0,
                height: 50.0,
              ),
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldCustom extends StatelessWidget {
  final String labelText;
  final TextInputType textInputType;
  final TextEditingController controller;
  final bool validate;
  const TextFieldCustom(
      {super.key,
      required this.labelText,
      required this.textInputType,
      required this.controller,
      required this.validate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: TextField(
        controller: controller,
        cursorColor: const Color(0xFF176B87),
        keyboardType: textInputType,
        decoration: InputDecoration(
          errorText: validate ? null : AppLocalizations.of(context)?.validation,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF176B87)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Color(0xFF176B87),
          ),
        ),
      ),
    );
  }
}

class PhoneTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool validate;

  const PhoneTextField(
      {super.key,
      required this.labelText,
      required this.controller,
      required this.validate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: IntlPhoneField(
        controller: controller,
        textAlign: TextAlign.right,
        cursorColor: const Color(0xFF176B87),
        initialCountryCode: 'EG',
        decoration: InputDecoration(
          errorText: validate ? null : AppLocalizations.of(context)!.validation,
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Color(0xFF507592),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF176B87)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(),
          ),
        ),
      ),
    );
  }
}

class DateTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isReserved;

  const DateTextField(
      {super.key,
      required this.labelText,
      required this.controller,
      required this.isReserved});

  @override
  State<DateTextField> createState() => _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: TextField(
        readOnly: true,
        controller: widget.controller,
        decoration: InputDecoration(
          errorText: widget.isReserved
              ? AppLocalizations.of(context)!.roomAlreadyReserved
              : null,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF176B87)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelText: widget.labelText,
          labelStyle: const TextStyle(
            color: Color(0xFF176B87),
          ),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2050),
          );
          if (pickedDate != null) {
            setState(() {
              widget.controller.text = DateFormat('yMMMd').format(pickedDate);
            });
          }
        },
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.id,
    required this.collectionName,
  });

  final String id;
  final String collectionName;

  deleteRecord(String id, String collectionName) {
    FirebaseFirestore.instance.collection(collectionName).doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ElevatedButton(
        style:
            ElevatedButton.styleFrom(backgroundColor: const Color(0xFF176B87)),
        onPressed: () {
          deleteRecord(id, collectionName);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.delete),
            const Icon(Icons.delete),
          ],
        ),
      ),
    );
  }
}

class BigDeleteButton extends StatelessWidget {
  const BigDeleteButton({
    super.key,
    required this.id,
    required this.collectionName,
  });

  final String id;
  final String collectionName;

  deleteRecord(String id, String collectionName) {
    FirebaseFirestore.instance.collection(collectionName).doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: SizedBox(
        width: double.infinity,
        height: 60.0,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFF176B87)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          onPressed: () {
            deleteRecord(id, collectionName);
          },
          child: Text(
            AppLocalizations.of(context)!.deleteHotel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  EditButton({
    super.key,
    required this.id,
    required this.collectionName,
    required this.amountPaid,
    required this.totalAmount,
    required this.hotelName,
    required this.clientName,
  });

  final String id;
  final String collectionName;
  final int amountPaid;
  final int totalAmount;
  final String hotelName;
  final String clientName;

  final amountRestController = TextEditingController();

  bool validate = true;

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
        var total = totalIncome! + int.parse(amountRestController.text);
        FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-$hotelName')
            .update({'totalIncome': total});
        var restTotal = totalRest! - int.parse(amountRestController.text);
        FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-$hotelName')
            .update({'totalRest': restTotal});
      },
    );
  }

  int? paidAmount;
  Future<void> updateAmountPaid() async {
    await FirebaseFirestore.instance.collection("reservations").get().then(
      (querySnapshot) async {
        paidAmount = await FirebaseFirestore.instance
            .collection('reservations')
            .doc('reserve-$clientName')
            .get()
            .then((value) {
          return value.data()?['amountPaid'];
        });
        var totalPaid = paidAmount! + int.parse(amountRestController.text);
        FirebaseFirestore.instance
            .collection('reservations')
            .doc('reserve-$clientName')
            .update({'amountPaid': totalPaid});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ElevatedButton(
        style:
            ElevatedButton.styleFrom(backgroundColor: const Color(0xFF176B87)),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.addAmount),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFieldCustom(
                        labelText: AppLocalizations.of(context)!.addAmount,
                        textInputType: TextInputType.text,
                        controller: amountRestController,
                        validate: validate,
                      ),
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.dismiss),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (validate) {
                          await updateAmountPaid();
                          await updateTotalIncome();
                          Navigator.pop(context);
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.edit),
                    ),
                  ],
                );
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.edit),
            const Icon(Icons.edit),
          ],
        ),
      ),
    );
  }
}

class EditRoomStateButton extends StatelessWidget {
  EditRoomStateButton({
    super.key,
    required this.id,
    required this.collectionName,
  });

  final String id;
  final String collectionName;

  final roomStatusController = TextEditingController();

  bool validate = true;

  Future<void> updateRoomStatus() async {
    await FirebaseFirestore.instance.collection(collectionName).get().then(
      (querySnapshot) {
        FirebaseFirestore.instance
            .collection(collectionName)
            .doc(id)
            .update({'roomStatus': roomStatusController.text});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ElevatedButton(
        style:
            ElevatedButton.styleFrom(backgroundColor: const Color(0xFF176B87)),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.roomStatus),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(AppLocalizations.of(context)!.roomStatus),
                      TextFieldCustom(
                        labelText: AppLocalizations.of(context)!.roomStatus,
                        textInputType: TextInputType.text,
                        controller: roomStatusController,
                        validate: validate,
                      ),
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.dismiss),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (validate) {
                          await updateRoomStatus();
                          Navigator.pop(context);
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.edit),
                    ),
                  ],
                );
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.edit),
            const Icon(Icons.edit),
          ],
        ),
      ),
    );
  }
}

class EditPasswordButton extends StatelessWidget {
  EditPasswordButton({
    super.key,
    required this.id,
    required this.collectionName,
  });

  final String id;
  final String collectionName;

  final passwordController = TextEditingController();

  bool validate = true;

  Future<void> updatePassword() async {
    await FirebaseFirestore.instance.collection(collectionName).get().then(
          (querySnapshot) {
        FirebaseFirestore.instance
            .collection(collectionName)
            .doc(id)
            .update({'password': passwordController.text});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ElevatedButton(
        style:
        ElevatedButton.styleFrom(backgroundColor: const Color(0xFF176B87)),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.editPassword),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFieldCustom(
                        labelText: AppLocalizations.of(context)!.newPassword,
                        textInputType: TextInputType.text,
                        controller: passwordController,
                        validate: validate,
                      ),
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.dismiss),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (validate) {
                          await updatePassword();
                          Navigator.pop(context);
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.edit),
                    ),
                  ],
                );
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.edit),
            const Icon(Icons.edit),
          ],
        ),
      ),
    );
  }
}

class EditStakeholderAmount extends StatelessWidget {
  EditStakeholderAmount({
    super.key,
    required this.id,
    required this.collectionName,
  });

  final String id;
  final String collectionName;

  final stakeholderAmountController = TextEditingController();

  bool validate = true;

  Future<void> updateStakeholderAmount() async {
    await FirebaseFirestore.instance.collection(collectionName).get().then(
          (querySnapshot) {
        FirebaseFirestore.instance
            .collection(collectionName)
            .doc(id)
            .update({'stakeholderAmount': int.parse(stakeholderAmountController.text)});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ElevatedButton(
        style:
        ElevatedButton.styleFrom(backgroundColor: const Color(0xFF176B87)),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.editAmount),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFieldCustom(
                        labelText: AppLocalizations.of(context)!.stakeholderAmount,
                        textInputType: TextInputType.text,
                        controller: stakeholderAmountController,
                        validate: validate,
                      ),
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.dismiss),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (validate) {
                          await updateStakeholderAmount();
                          Navigator.pop(context);
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.edit),
                    ),
                  ],
                );
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.edit),
            const Icon(Icons.edit),
          ],
        ),
      ),
    );
  }
}

class EditHotelButton extends StatelessWidget {
  EditHotelButton({
    super.key,
    required this.id,
    required this.collectionName,
  });

  final String id;
  final String collectionName;

  final hotelNameController = TextEditingController();

  bool validate = true;
  int? paidAmount;
  Future<void> updateHotelName() async {

    DocumentSnapshot snapshot= await FirebaseFirestore.instance.collection(collectionName).doc(id).get();
    var document=snapshot.data;
    FirebaseFirestore.instance.collection(collectionName).doc('hotel-${hotelNameController.text}').set(document() as Map<String, dynamic>);
    FirebaseFirestore.instance.collection(collectionName).doc(id).delete();

        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc('hotel-${hotelNameController.text}')
            .update({'hotelName': hotelNameController.text});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: SizedBox(
        width: double.infinity,
        height: 60.0,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0xFF176B87)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.editHotel),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFieldCustom(
                          labelText: AppLocalizations.of(context)!.hotelName,
                          textInputType: TextInputType.text,
                          controller: hotelNameController,
                          validate: validate,
                        ),
                      ],
                    ),
                    actions: [
                      MaterialButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.dismiss),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          if (validate) {
                            await updateHotelName();
                            Navigator.pop(context);
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.editHotel),
                      ),
                    ],
                  );
                });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.editHotel,style: const TextStyle(
          color: Colors.white,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),),
            ],
          ),
        ),
      ),
    );
  }
}

class PrintButton extends StatelessWidget {
  const PrintButton({
    super.key,
    required this.hotelName,
    required this.clientName,
    required this.nationality,
    required this.clientNationalId,
    required this.clientNumber,
    required this.roomNumber,
    required this.startDate,
    required this.endDate,
    required this.amountPaid,
    required this.amountRest,
    required this.amountTotal,
  });

  final String hotelName;
  final String clientName;
  final String nationality;
  final String clientNationalId;
  final int clientNumber;
  final String roomNumber;
  final DateTime startDate;
  final DateTime endDate;
  final int amountPaid;
  final int amountRest;
  final int amountTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ElevatedButton(
        style:
            ElevatedButton.styleFrom(backgroundColor: const Color(0xFF176B87)),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PdfPrev(
                        hotelName: hotelName,
                        clientName: clientName,
                        nationality: nationality,
                        clientId: clientNationalId,
                        clientNumber: clientNumber.toString(),
                        roomNumber: roomNumber,
                        startDate: startDate.toString(),
                        endDate: endDate.toString(),
                        amountPaid: amountPaid.toString(),
                        amountRest: amountRest.toString(),
                        amountTotal: amountTotal.toString(),
                      )));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.print),
            const Icon(Icons.print),
          ],
        ),
      ),
    );
  }
}

class PrintOutcomeButton extends StatelessWidget {
  const PrintOutcomeButton({
    super.key,
    required this.outcomeName,
    required this.outcomeTo,
    required this.thatAbout,
    required this.amount,
  });

  final String outcomeName;
  final String outcomeTo;
  final String thatAbout;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ElevatedButton(
        style:
            ElevatedButton.styleFrom(backgroundColor: const Color(0xFF176B87)),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OutcomePdfPrev(
                        outcomeName: outcomeName,
                        outcomeTo: outcomeTo,
                        thatAbout: thatAbout,
                        amount: amount.toString(),
                      )));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.print),
            const Icon(Icons.print),
          ],
        ),
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool obscureText;
  final IconData icon;

  const LoginTextField({
    super.key,
    required this.labelText,
    required this.keyboardType,
    required this.controller,
    required this.obscureText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: TextField(
        controller: controller,
        cursorColor: const Color(0xFF176B87),
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          prefixIconColor: const Color(0xFF176B87),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF176B87)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Color(0xFF176B87),
          ),
        ),
      ),
    );
  }
}
