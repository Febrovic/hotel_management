import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/card_widget.dart';
import 'package:hotel_managmenet/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:hotel_managmenet/reusable_component.dart';

class ShareCapitalPage extends StatefulWidget {
  final int clientType;
  const ShareCapitalPage({super.key, required this.clientType});

  @override
  State<ShareCapitalPage> createState() => _ShareCapitalPageState();
}
List<Widget> infoCard = [];
class _ShareCapitalPageState extends State<ShareCapitalPage> {


  final stakeholderNameController = TextEditingController();
  final stakeholderAmountController = TextEditingController();
  bool stakeholderNameValidate = true;
  bool stakeholderAmountValidate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.appBarBGColor,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.shareCapital),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ButtonWithoutImage(
                  text: AppLocalizations.of(context)!.addStakeholder,
                  pressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.addStakeholder),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFieldCustom(
                                  labelText:
                                  AppLocalizations.of(context)!.stakeholderName,
                                  textInputType: TextInputType.text,
                                  controller: stakeholderNameController,
                                  validate: stakeholderNameValidate,
                                ),
                                TextFieldCustom(
                                  labelText:
                                  AppLocalizations.of(context)!.stakeholderAmount,
                                  textInputType: TextInputType.number,
                                  controller: stakeholderAmountController,
                                  validate: stakeholderAmountValidate,
                                ),
                              ],
                            ),
                            actions: [
                              MaterialButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                child:
                                Text(AppLocalizations.of(context)!.dismiss),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    stakeholderNameController.text.isNotEmpty
                                        ? stakeholderNameValidate = true
                                        : stakeholderNameValidate = false;
                                    stakeholderAmountController.text.isNotEmpty
                                        ? stakeholderAmountValidate = true
                                        : stakeholderAmountValidate = false;
                                  });
                                  if (stakeholderNameValidate == true &&
                                      stakeholderAmountValidate == true) {
                                    final CollectionReference postsRef =
                                    FirebaseFirestore.instance
                                        .collection('stakeholders');
                                    var postID =
                                        'stakeholder-${stakeholderNameController.text}';
                                    DocumentReference ref =
                                    postsRef.doc(postID);
                                    ref.set({
                                      'stakeholderName': stakeholderNameController.text,
                                      'stakeholderAmount': int.parse(stakeholderAmountController.text),
                                      'clientType':widget.clientType,
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                                child:
                                Text(AppLocalizations.of(context)!.addStakeholder),
                              ),
                            ],
                          );
                        });
                  }),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('stakeholders').snapshots(),
                builder: (context, snapshot) {
                  infoCard = [];
                  if (snapshot.hasData) {
                    final stakeholders = snapshot.data?.docs;
                    for (var stakeholder in stakeholders!) {
                      if(widget.clientType == stakeholder.data()['clientType']||widget.clientType == 0){
                        final stakeholderName = stakeholder.data()['stakeholderName'];
                        final stakeholderAmount = stakeholder.data()['stakeholderAmount'];
                        infoCard.add(
                          InfoCard(
                            child: StakeholdersInfoCard(
                              stakeholderName: stakeholderName,
                              stakeholderAmount:stakeholderAmount,
                            ),
                          ),
                        );
                      }
                    }
                    return infoCard.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: Text(
                            AppLocalizations.of(context)!.noClientsYet),
                      ),
                    )
                        : Column(
                      children: infoCard,
                    );
                  } else {
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
