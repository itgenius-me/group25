import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:streambox/config/date.dart';
import 'package:streambox/config/enumvals.dart';
import 'package:streambox/config/firebase.dart';
import 'package:streambox/providers/birds_prov.dart';
import 'package:streambox/providers/egg_prov.dart';
import 'package:streambox/widgets/stock_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Stock extends StatefulWidget {

          

  @override
  _StockState createState() => _StockState();
}

class _StockState extends State<Stock> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> updateStockUI() async {
    DocumentReference documentRefEggs =
        _firestore.collection('stock_eggs').doc(auth.currentUser.uid);
    DocumentReference documentRefChickens =
        _firestore.collection('stock_chickens').doc(auth.currentUser.uid);
    _firestore.runTransaction((transaction) async {
      DocumentSnapshot<Map> eggSnapshot =
          await transaction.get(documentRefEggs);
      DocumentSnapshot<Map> chickenSnapshot =
          await transaction.get(documentRefChickens);
      if (eggSnapshot.exists) {
        if (eggSnapshot.data().containsKey(formatDate())) {
          Provider.of<EggProv>(
            context,
            listen: false,
          ).setPercent(1.0);
        } else {
          Provider.of<EggProv>(
            context,
            listen: false,
          ).setPercent(0.0);
        }
      }
      if (chickenSnapshot.exists) {
        int batchesCounted = 0;
        for (var batch in chickenSnapshot.data().keys) {
          Map stock = chickenSnapshot.data()[batch]["stock"];
          if (stock.containsKey(formatDate())) {
            batchesCounted++;
          }
        }
        Provider.of<BirdsProv>(context, listen: false)
            .setBatchesCounted(batchesCounted);
        Provider.of<BirdsProv>(context, listen: false).setNumberOfbatches(
          chickenSnapshot.data().length,
        );
      }
    });
  }

  @override
  // ignore: must_call_super
  void initState() {
    super.initState();
    updateStockUI();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Color(0XFF35D4C0),
      onRefresh: updateStockUI,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.0),
        child: ListView(
          children: [
            StockCard(
              name: "Chickens",
              itemCount: Provider.of<BirdsProv>(context).batchCount,
              itemsCounted: Provider.of<BirdsProv>(context).batchesCounted,
              reportCategory: StockReport.chickens,
              completionRate: Provider.of<BirdsProv>(context).getStockPercent(),
            ),
            StockCard(
              name: "Eggs",
              itemCount: 1,
              itemsCounted:
                  Provider.of<EggProv>(context).percentage == 1.0 ? 1 : 0,
              reportCategory: StockReport.eggs,
              completionRate: Provider.of<EggProv>(context).percentage,
            ),
          ],
        ),
      ),
    );
  }
}
