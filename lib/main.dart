import 'package:flutter/material.dart';
import 'package:nowapps_round2/supporting_files/cart_provider.dart';
import 'package:nowapps_round2/screens/home_page.dart';
import 'package:nowapps_round2/screens/login_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CartProvider(),
        child: Builder(builder: (context) {
          return FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (BuildContext context,
                  AsyncSnapshot<SharedPreferences> prefs) {
                if (prefs.hasData) {
                  bool isLoggedIn = (prefs.data?.getBool('isLoggedIn') == null)
                      ? false
                      : true;
                  if (isLoggedIn) {
                    return const MaterialApp(home: HomePage());
                  }
                }

                return const MaterialApp(home: LoginPage());
              });
        }));
  }
}
