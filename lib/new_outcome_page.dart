import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:hotel_managmenet/pdf_perview.dart';
import 'package:hotel_managmenet/reusable_component.dart';
class NewOutcomePage extends StatefulWidget {
  NewOutcomePage({Key? key, required this.hotelName}) : super(key: key);


  final String hotelName;

  @override
  State<NewOutcomePage> createState() => _NewOutcomePageState();
}

class _NewOutcomePageState extends State<NewOutcomePage> {
  final outcomeNameController = TextEditingController();
  bool outcomeNameValidate = true;
  final outcomeToController = TextEditingController();
  bool outcomeToValidate = true;
  final thatAboutController = TextEditingController();
  bool thatAboutValidate = true;
  final amountController = TextEditingController();
  bool amountValidate = true;

  int? totalOutcome;

  Future<void> updateTotalOutcome() async {
    await FirebaseFirestore.instance.collection("hotels").get().then(
          (querySnapshot) async {

            totalOutcome = await FirebaseFirestore.instance
                .collection('hotels')
                .doc('hotel-${widget.hotelName}')
                .get()
                .then((value) {
              return value
                  .data()?['totalOutcome'];
            });
            var total = totalOutcome! + int.parse(amountController.text);
            print(total);
        await FirebaseFirestore.instance
            .collection('hotels')
            .doc('hotel-${widget.hotelName}')
            .update({'totalOutcome': total});
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
        title: Text(AppLocalizations.of(context)!.addOutcome),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldCustom(
              controller: outcomeNameController,
              labelText: AppLocalizations.of(context)!.outcomeName,
              textInputType: TextInputType.text,
              validate: outcomeNameValidate,
            ),
            TextFieldCustom(
              controller: outcomeToController,
              labelText: AppLocalizations.of(context)!.outcomeTo,
              textInputType: TextInputType.text,
              validate: outcomeToValidate,
            ),
            TextFieldCustom(
              controller: thatAboutController,
              labelText: AppLocalizations.of(context)!.thatAbout,
              textInputType: TextInputType.text,
              validate: thatAboutValidate,
            ),
            TextFieldCustom(
              controller: amountController,
              labelText: AppLocalizations.of(context)!.amount,
              textInputType: TextInputType.number,
              validate: amountValidate,
            ),
            ButtonWithoutImage(
              text: AppLocalizations.of(context)!.addOutcome,
              pressed:
                  ()  {
                setState(() {
                  outcomeNameController.text.isNotEmpty ? outcomeNameValidate = true:outcomeNameValidate = false;
                  outcomeToController.text.isNotEmpty ? outcomeToValidate = true:outcomeToValidate = false;
                  thatAboutController.text.isNotEmpty ? thatAboutValidate = true:thatAboutValidate = false;
                  amountController.text.isNotEmpty ? amountValidate = true: amountValidate = false;
                });

                if(outcomeNameValidate == true && outcomeToValidate == true && thatAboutValidate == true && amountValidate == true){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title:
                          Text(AppLocalizations.of(context)!.addOutcome),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  '${AppLocalizations.of(context)!.outcomeName} : ${outcomeNameController.text}'),
                              Text(
                                  '${AppLocalizations.of(context)!.outcomeTo} : ${outcomeToController.text}'),
                              Text(
                                  '${AppLocalizations.of(context)!.thatAbout} : ${thatAboutController.text}'),
                              Text(
                                  '${AppLocalizations.of(context)!.amount} : ${amountController.text}'),
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
                              onPressed: () async {
                                final CollectionReference postsRef = FirebaseFirestore.instance
                                    .collection('outcome');
                                var postID =
                                    '${outcomeNameController.text}-${amountController.text}';
                                DocumentReference ref = postsRef.doc(postID);
                                ref.set({
                                  'hotelName':widget.hotelName,
                                  'outcomeName': outcomeNameController.text,
                                  'outcomeTo': outcomeToController.text,
                                  'thatAbout': thatAboutController.text,
                                  'amount':
                                  int.parse(amountController.text),
                                });
                                await updateTotalOutcome();
                                Navigator.pop(context);
                              },
                              child: Text(
                                  AppLocalizations.of(context)!.addOutcome),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OutcomePdfPrev(
                                          outcomeName: outcomeNameController.text,
                                          outcomeTo: outcomeToController.text,
                                          thatAbout: thatAboutController.text,
                                          amount: amountController.text,
                                        )));
                              },
                              child: Text(AppLocalizations.of(context)!.print),
                            ),
                          ],
                        );
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
