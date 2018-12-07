import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kissaan_flutter/locale/locales.dart';

class BeginnerTasks extends StatelessWidget {
  final String phoneNumber;

  BeginnerTasks(this.phoneNumber);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot> (
      stream: Firestore.instance.collection("users")
        .where("phoneNumber", isEqualTo: phoneNumber)
        .limit(1)
        .snapshots(),

      builder: (_, AsyncSnapshot<QuerySnapshot> userSnap) {
        if (!userSnap.hasData)
          return Container();

        DateTime dateRegistered = DateTime
          .fromMillisecondsSinceEpoch(
            int.parse(
              userSnap.data.documents[0].data["dateRegistered"]
            )
          );

        int daysSinceRegistration = DateTime.now()
          .difference(dateRegistered)
          .inDays;

        if (daysSinceRegistration <= 7) {
          return Column(children: <Widget>[
            ListTile(
              leading: Image.asset(
                "assets/icons/all_cattle.png",
                width: 40.0
              ),
              title: Text(
                  AppLocalizations.of(context).registerUsingAddCattle
              ),
            ),
            ListTile(
              leading: Image.asset(
                "assets/icons/Delivery.png",
                width: 40.0
              ),
              title: Text(
                  AppLocalizations.of(context).registerCattleEvents
              )
            ),
            ListTile(
              leading: Image.asset(
                "assets/icons/tip_icon.png", 
                width: 40.0
              ),
              title: Text(
                  AppLocalizations.of(context).checkTipOfDay
              )
              ),
            ListTile(
              leading: Icon(
                IconData(
                  0xe802, 
                  fontFamily: 
                  "Kissaan"
                )
              ),
              title: Text(
                  AppLocalizations.of(context).updateAnimalYields
              )
            ),
          ]
          );
        }
        return Container();
      }
    );
  }
}