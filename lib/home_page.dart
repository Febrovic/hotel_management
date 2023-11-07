import 'package:flutter/material.dart';
import 'package:hotel_managmenet/constants.dart';
import 'package:hotel_managmenet/reusable_component.dart';
import 'clients_page.dart';
import 'reports_page.dart';
import 'reservations_page.dart';
import 'rooms_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class HomePage extends StatelessWidget {

  final int? userType;
  final int clientType;
  final String username;

  const HomePage({super.key, this.userType, required this.clientType, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.appBarBGColor,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.homePage),
      ),
      body: SafeArea(
        child: Column(children: [
          ButtonWithImage(
            text: AppLocalizations.of(context)!.reservations,
            imgPath: 'assets/reservation.svg',
            pressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReservationsPage(
                            userType: userType,
                          clientType:clientType,
                          )));
            },
          ),
          ButtonWithImage(
            text: AppLocalizations.of(context)!.rooms,
            imgPath: 'assets/rooms.svg',
            pressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RoomsPage(
                            userType: userType,
                        clientType:clientType,
                          )));
            },
          ),
          ButtonWithImage(
            text: AppLocalizations.of(context)!.clients,
            imgPath: 'assets/clients.svg',
            pressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClientsPage(
                            userType: userType,
                        clientType:clientType,
                          )));
            },
          ),
          userType == 1
              ? ButtonWithImage(
                  text: AppLocalizations.of(context)!.reports,
                  imgPath: 'assets/cash.svg',
                  pressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Reports(clientType:clientType,username: username,)));
                  },
                )
              : const SizedBox(),
        ]),
      ),
    );
  }
}
