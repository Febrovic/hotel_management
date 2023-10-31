import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managmenet/add_employee_page.dart';
import 'package:hotel_managmenet/card_widget.dart';
import 'package:hotel_managmenet/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class EmployeesPage extends StatefulWidget {
  final int clientType;

  const EmployeesPage({super.key, required this.clientType});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

List<Widget> infoCard = [];

class _EmployeesPageState extends State<EmployeesPage> {

  final _firestore = FirebaseFirestore.instance;
  String hotelDropdownValue = 'اسم الفندق';
  var hotels = [
    'اسم الفندق',
  ];

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.appBarBGColor,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.employeesInformation),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF176B87)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewEmployeePage(clientType: widget.clientType,)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        size: 30,
                      ),
                      Text(
                        AppLocalizations.of(context)!.addEmployee,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('employees')
                    .snapshots(),
                builder: (context, snapshot) {
                  infoCard = [];
                  if (snapshot.hasData) {
                    final employees = snapshot.data?.docs;
                    for (var employee in employees!) {
    if (hotelDropdownValue == employee.data()['hotelName']) {
      final employeeName = employee.data()['employeeName'];
      final employeeNumber = employee.data()['employeeNumber'];
      final employeeJobTitle =
      employee.data()['employeeTitleJob'];
      final employeeTask = employee.data()['employeeTask'];
      final employeeSalary = employee.data()['employeeSalary'];
      infoCard.add(
        InfoCard(
          child: EmployeeInfoCard(
            employeeName: employeeName,
            employeeJobTitle: employeeJobTitle,
            employeeTask: employeeTask,
            employeeNumber: employeeNumber,
            employeeSalary: employeeSalary,
          ),
        ),
      );
    }
                    }
                    return infoCard.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: 50.0),
                            child: Center(
                              child: Text(AppLocalizations.of(context)!
                                  .noEmployee),
                            ),
                          )
                        : Column(
                            children: infoCard,
                          );
                  } else {
                    return const Center(child: CircularProgressIndicator());
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
