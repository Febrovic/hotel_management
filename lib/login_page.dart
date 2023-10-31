import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:hotel_managmenet/home_page.dart';
import 'package:hotel_managmenet/reusable_component.dart';

class LoginPage extends StatelessWidget {

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isUser = false;
  int? userType;
  int clientType = 0;

  LoginPage({super.key});
  Future<void> getUser() async {
    await FirebaseFirestore.instance.collection("users").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if(userNameController.text == docSnapshot.data()['username']&&passwordController.text ==docSnapshot.data()['password']){
            isUser = true;
            userType = docSnapshot.data()['userType'];
            clientType = docSnapshot.data()['clientType'];
            break;
          }else{
            isUser = false;
          }

        }
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
        title: Text(AppLocalizations.of(context)!.loginPage),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginTextField(
              labelText: AppLocalizations.of(context)!.userName,
              keyboardType: TextInputType.text,
              controller: userNameController,
              obscureText: false,
              icon: Icons.account_circle_outlined,
            ),
            LoginTextField(
              labelText: AppLocalizations.of(context)!.password,
              keyboardType: TextInputType.text,
              controller: passwordController,
              obscureText: true,
              icon: Icons.password,
            ),
            ButtonWithoutImage(text: AppLocalizations.of(context)!.login, pressed: ()async{
              await getUser();
               isUser ? Navigator.push(
                   context,
                   MaterialPageRoute(
                       builder: (context) => HomePage(userType: userType,clientType:clientType,))): null;
            })
          ],
        ),
      ),
    );
  }
}
