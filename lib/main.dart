import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:streambox/config/firebase.dart';
import 'package:streambox/config/shared_pref.dart';
import 'package:streambox/distributor/home.dart';
import 'package:streambox/providers/data_prov.dart';
import 'package:streambox/providers/order_prov.dart';
import 'package:streambox/providers/price_prov.dart';
import 'package:streambox/screens/layout.dart';
import 'package:streambox/screens/onboarding_ui/login.dart';
import 'package:streambox/providers/birds_prov.dart';
import 'package:streambox/providers/farm_prov.dart';
import 'package:streambox/providers/layout_index.dart';
import 'package:streambox/providers/user_prov.dart';
import 'package:streambox/providers/egg_prov.dart';
import 'package:streambox/widgets/scroll_behaviour.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path/path.dart';
// import 'package:excel/excel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
//   The below lines are only useful for local dev purposes
//   Comment them out when using production backend
//  store.settings = Settings(
//    host: storeHost,
//    sslEnabled: false,
//  );
//  await auth.useEmulator(authHost);
  // get shared_prefs instance
  prefs = await SharedPreferences.getInstance();
  //print("User ID: ${auth.currentUser.uid}");
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProv>(
          create: (_) => UserProv(),
        ),
        ChangeNotifierProvider<FarmProv>(
          create: (_) => FarmProv(),
        ),
        ChangeNotifierProvider<LayoutIndexProv>(
          create: (_) => LayoutIndexProv(),
        ),
        ChangeNotifierProvider<EggProv>(
          create: (_) => EggProv(),
        ),
        ChangeNotifierProvider<BirdsProv>(
          create: (_) => BirdsProv(),
        ),
        ChangeNotifierProvider<DataProv>(
          create: (_) => DataProv(),
        ),
        ChangeNotifierProvider<OrderProv>(
          create: (_) => OrderProv(),
        ),
        ChangeNotifierProvider<PriceProv>(
          create: (_) => PriceProv(),
        ),
      ],
      child: MaterialApp(
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child,
          );
        },
        title: 'Poultry Management',
        theme: ThemeData(
          // primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: prefs.getString("userID") == null
            ? Login()
            : prefs.getString("role") == "farmer"
                ? Layout()
                : DistributorHome(),
      ),
    );
  }
}
