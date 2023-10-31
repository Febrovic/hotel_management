import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:hotel_managmenet/new_outcome_page.dart';
import 'package:hotel_managmenet/reusable_component.dart';

import 'card_widget.dart';

List<Widget> infoCard = [
];
class OutcomePage extends StatefulWidget {


  final String hotelName;

  OutcomePage({super.key, required this.hotelName});

  @override
  State<OutcomePage> createState() => _OutcomePageState();
}

class _OutcomePageState extends State<OutcomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.appBarBGColor,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.reports),
      ),
      body: SafeArea(
        child:
        SingleChildScrollView(
          child: Column(
            children: [
              ButtonWithoutImage(text: AppLocalizations.of(context)!.addOutcome, pressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewOutcomePage(hotelName: widget.hotelName,)));
              }),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('outcome').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    infoCard=[];
                    final outcomes = snapshot.data?.docs;
                    for (var outcome in outcomes!) {
                      if(widget.hotelName == outcome.data()['hotelName']){
                        final outcomeName = outcome.data()['outcomeName'];
                        final outcomeTo = outcome.data()['outcomeTo'];
                        final thatAbout = outcome.data()['thatAbout'];
                        final amount= outcome.data()['amount'];
                        infoCard.add(
                          InfoCard(
                            child: OutcomeInfoCard(
                              outcomeName: outcomeName,
                              outcomeTo: outcomeTo,
                              thatAbout: thatAbout,
                              amount: amount,
                            ),
                          ),
                        );
                      }
                    }
                    return infoCard.isEmpty? Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Center(child: Text(AppLocalizations.of(context)!.noOutcomesYet),),
                    ):Column(
                      children: infoCard,
                    );
                  }else{
                    return const CircularProgressIndicator();
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
