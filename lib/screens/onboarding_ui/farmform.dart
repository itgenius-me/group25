import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:streambox/config/constants.dart';
import 'package:streambox/config/enumvals.dart';
import 'package:streambox/config/shared_pref.dart';
import 'package:streambox/providers/price_prov.dart';
import 'package:streambox/providers/user_prov.dart';
import 'package:streambox/screens/layout.dart';
import 'package:streambox/providers/farm_prov.dart';
import 'package:streambox/widgets/inputfield.dart';
import 'package:streambox/widgets/picker.dart';
import 'package:streambox/config/firebase.dart';
import 'package:streambox/widgets/toast.dart';
import 'package:provider/provider.dart';

class FarmForm extends StatefulWidget {
  @override
  _FarmFormState createState() => _FarmFormState();
}

class _FarmFormState extends State<FarmForm> {
  final _farmFormKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ProgressHUD(
          child: Builder(
            builder: (context) => Form(
              key: _farmFormKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Consumer<FarmProv>(
                builder: (context, farm, child) {
                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 20, top: 20),
                        child: Text(
                          "Farm Details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      InputField(
                        name: "Farm name",
                        keyboard: TextInputType.text,
                        fieldType: FieldType.farmName,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: InputField(
                                name: "LGA",
                                keyboard: TextInputType.text,
                                fieldType: FieldType.lga),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
//                                Padding(
//                                  padding: const EdgeInsets.only(
//                                      left: 35.0, right: 20.0),
//                                  child: Align(
//                                    alignment: Alignment.centerLeft,
//                                    child: Text(
//                                      "State",
//                                      style: TextStyle(
//                                        fontWeight: FontWeight.bold,
//                                      ),
//                                      //textAlign: TextAlign.left,`
//                                    ),
//                                  ),
//                                ),
//                                Align(
//                                  alignment: Alignment.topRight,
//                                  child: Padding(
//                                    padding: EdgeInsets.only(
//                                        left: 20.0,
//                                        top: 5,
//                                        bottom: 20,
//                                        right: 20.0),
//                                    child: customPicker(
//                                      context,
//                                      nigerianStates,
//                                      Color(0XFFEAE9EB),
//                                      Provider.of<FarmProv>(context).state,
//                                      (value) {
//                                        Provider.of<FarmProv>(context,
//                                                listen: false)
//                                            .setState(
//                                          value,
//                                        );
//                                      },
//                                    ),
//                                  ),
//                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InputField(
                              name: "Number of Broilers",
                              maxlen: 5,
                              keyboard: TextInputType.number,
                              fieldType: FieldType.numberOfBroilers,
                            ),
                          ),
                          Expanded(
                            child: InputField(
                              name: "Number of Layers",
                              maxlen: 5,
                              keyboard: TextInputType.number,
                              fieldType: FieldType.numberOfLayers,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InputField(
                              name: "Egg unit price",
                              keyboard: TextInputType.number,
                              fieldType: FieldType.crateOfEggPrice,
                              //rightPadding: 20,
                              maxlen: 4,
                              fontSize: 17,
                            ),
                          ),
                          Expanded(
                            child: InputField(
                              name: "Chicken unit price",
                              keyboard: TextInputType.number,
                              fieldType: FieldType.chickenPrice,
                              // rightPadding: 20,
                              maxlen: 4,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          final _progress = ProgressHUD.of(context);
                          if (_farmFormKey.currentState.validate()) {
                            _progress.showWithText("Registering farm...");
                            try {
                              await _firestore
                                  .collection("farmers")
                                  .doc()
                                  .set(
                                {
                                  "userID": auth.currentUser.uid,
                                  "user": Provider.of<UserProv>(
                                    context,
                                    listen: false,
                                  ).name,
                                  "farmName": farm.farmName,
                                  "address": Provider.of<UserProv>(
                                    context,
                                    listen: false,
                                  ).address,
                                  "LGA": farm.lga,
//                                  "State": farm.state,
                                  "numberOfBroilers": int.parse(
                                    farm.broilersCount,
                                  ),
                                  "numberOfLayers": int.parse(
                                    farm.layersCount,
                                  ),
                                  "crateOfEggPrice": Provider.of<PriceProv>(
                                          context,
                                          listen: false)
                                      .cratePrice,
                                  "chickenPrice": Provider.of<PriceProv>(
                                          context,
                                          listen: false)
                                      .chickenPrice,
                                  "contact": Provider.of<UserProv>(context,
                                          listen: false)
                                      .phoneNumber,
                                },
                              );
                              prefs.setString(
                                "farmName",
                                farm.farmName,
                              );
                              prefs.setInt("totalChickens", 0);
                              prefs.setInt("openOrders", 0);
                              prefs.setInt("eggsCollected", 0);
                              _progress.dismiss();
                              ;
                            } catch (e) {
                              _progress.dismiss();
                              toaster(
                                e.code,
                                ToastGravity.BOTTOM,
                              );
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 5,
                          ),
                          child: Card(
                            color: Color(0XFF35D4C0),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Register Farm",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
