import 'package:flutter/material.dart';
import 'package:nowapps_round2/global_variables.dart';
import 'package:nowapps_round2/screens/login_page.dart';
import 'package:nowapps_round2/screens/retailer_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> get productTypeList =>
      ["Croma", "Reliance Digital", "Vijay Sales"];
  bool isRetailerSelected = false;
  String? retailerSelected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "SELECT RETAILER",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await saveLogoutState();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: _buildCheckInForm(),
    );
  }

  Widget _buildCheckInForm() {
    return Column(
      children: [
        buildRetailersList(),
        viewRetailersInformation(retailerSelected ?? ""),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                child: const Text('Checkin'),
                onPressed: () async {
                  if (retailerSelected != null) {
                    await saveCheckIn(retailerSelected!);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RetailerPage()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please select a retailer to check in."),
                    ));
                  }
                },
              )),
        ),
      ],
    );
  }

  buildRetailersList() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.045,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: retailerSelected,
                items: productTypeList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
                elevation: 2,
                hint: const Text("Select a retailer",
                    style: TextStyle(
                      color: Color.fromARGB(255, 115, 114, 114),
                    )),
                onChanged: (String? value) {
                  setState(() {
                    retailerSelected = value!;
                  });
                },
                icon: const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Color.fromARGB(255, 115, 114, 114),
                  size: 20,
                ),
                isExpanded: true,
                dropdownColor: Colors.white,
              ),
            ),
          ),
        ),
        const Divider(
          thickness: 0.7,
          color: Color.fromARGB(255, 100, 99, 99),
        ),
      ],
    );
  }

  viewRetailersInformation(String retailerName) {
    if (retailerName == "") {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.network(GlobalVariables
                    .retailerDetails[retailerName]["shopImage"])),
            const Text(
              "Retailer Details",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Text("Shop Name: " +
                GlobalVariables.retailerDetails[retailerName]["shopName"]),
            Text("Owner Name: " +
                GlobalVariables.retailerDetails[retailerName]["ownerName"]),
            Text("Address: " +
                GlobalVariables.retailerDetails[retailerName]["address"]),
            Text("Mobile No.: " +
                GlobalVariables.retailerDetails[retailerName]["mobileNo"]),
            Text("City: " +
                GlobalVariables.retailerDetails[retailerName]["city"]),
            Text("State: " +
                GlobalVariables.retailerDetails[retailerName]["state"]),
          ],
        ),
      );
    }
  }

  saveCheckIn(String retailer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('checkIn', retailer);
  }

  saveLogoutState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');
  }
}
