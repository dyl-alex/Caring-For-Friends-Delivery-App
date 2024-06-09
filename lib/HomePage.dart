import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test/models/Recipient.dart';
import 'globals.dart';
import 'CffApi.dart';
import 'models/Delivery.dart';
import 'models/Recipient2.dart';
import 'models/User.dart';
import 'RecipientTile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _homePageState();
}

class _homePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    setMyUser();
    print(myUser.firstName);
    currentOrgUserRecipients = getUserRecipientsByOrg();
    numUserRecipientsByOrg = getNumUserRecipients(currentOrgUserRecipients);
    userDeliveries = getUserDeliveries(currentOrgUserRecipients);
    _numRecipientsForToday = getNumDeliveries(userDeliveries);
    userRecipients = getUserRecipients(userDeliveries, currentOrgUserRecipients);
  }

  late Future<List<Delivery>> userDeliveries;
  late Future<List<Recipient2>> userRecipients;
  late Future<List<Recipient2>> currentOrgUserRecipients;
  late Future<int> numUserRecipientsByOrg;
  late Future<int> _numRecipientsForToday;

  setMyUser() async{
    myUser = await myAPI.getUser("4c55ec32-6872-46e3-a3ef-587b9fc8b7b6");
  }

  Future<List<Recipient2>> getUserRecipients(Future<List<Delivery>> currentDeliveries, Future<List<Recipient2>> allRecipients) async {
    int index = 0;
    List<Delivery> deliveries = await currentDeliveries;
    int numDeliveries = deliveries.length;

    List<Recipient2> recipients = await allRecipients;
    List<Recipient2> recipientsForToday = [];

    if (deliveries.isEmpty) {
      print("no deliveries today - no recipients needed");
    }
    else {
      for (var currentRecipient in recipients) {
        for (index; index < numDeliveries; index++) {
          if(currentRecipient.getID() == deliveries[index].getRecipientID()) {
            recipientsForToday.add(currentRecipient);
          }
        }
      }
    }
    return recipientsForToday;

  }

  //show a user's deliveries, filtered by the current date and the organization
  Future<List<Delivery>> getUserDeliveries(Future<List<Recipient2>> userRecipients) async {
    int index = 0;
    List<Delivery> userDeliveriesByOrg = [];
    List<Delivery> userDeliveriesForToday = await myAPI.getUserDeliveryByDate(myUser.getID(), DateTime.now().toIso8601String());

    List<Recipient2> recipients = await userRecipients;
    int numRecipients = recipients.length;

    if(userDeliveriesForToday.isEmpty) {
      print("no deliveries today");
    }
    else {
      for (var currentDelivery in userDeliveriesForToday) {
        for (index; index < numRecipients; index++) {
          if (currentDelivery.getRecipientID() == recipients[index].getID()) {
            userDeliveriesByOrg.add(currentDelivery);
          }
        }
        print("num deliveries is ${userDeliveriesByOrg.length}");
      }
    }
    return userDeliveriesByOrg;
  }

  //shows a user's recipients filtered by the organization
  Future<List<Recipient2>> getUserRecipientsByOrg() async {
    int index = 0;
    currentUser = await myAPI.getUser("4c55ec32-6872-46e3-a3ef-587b9fc8b7b6");

    List<Recipient2> allRecipients = await myAPI.getUserRecipients(myUser.getID());

    List<Recipient2> recipientsByOrganization = [];

    for (var currentRecipient in allRecipients) {
      if (currentRecipient.getOrgId() == currentOrg.getOrgID()) {
        recipientsByOrganization.add(currentRecipient);
      }
    }
    return recipientsByOrganization;
  }

  Future<int> getNumUserRecipients(Future<List<Recipient2>> recipientList) async {
    int index = 0;

    List<Recipient2> allRecipients = await recipientList;

    for (var currentRecipient in allRecipients) {
      index++;
    }

    return index;
  }

  Future<int> getNumDeliveries(Future<List<Delivery>> userDeliveries) async {
    List<Delivery> currentDeliveries = await userDeliveries;
    return currentDeliveries.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([userRecipients, _numRecipientsForToday]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          List<Widget> children = [];
          String greeting = "";
          if (snapshot.hasData) {
            print("userecipients = ${snapshot.data?[0]} and _numRecipients = ${snapshot.data?[1]}");
            if (snapshot.data?[1] == 0) {
              greeting = "You have no deliveries today";
            }
            else if (snapshot.data?[1] == 1) {
              greeting = "You have 1 delivery today";
            }
            else {
              greeting = "You have ${snapshot.data?[1]} deliveries today";
            }
            children = [
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 20.0),
                child: Column(
                  children: [
                    Text("Hello, ${myUser.firstName}!",
                      style: const TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 5.0),
                      child: Text(greeting,
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ];
            children += <Widget> [
              for (int index = 0; index < snapshot.data?[1]; index++)
                RecipientTile(currentRecipient: snapshot.data?[0][index]),
            ];
          }
          return ListView(
            children: children,
            // children: [
            //   Padding(
            //     padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 20.0),
            //     child: Column(
            //       children: [
            //         Text("Hello, ${myUser.firstName}!",
            //         style: const TextStyle(
            //             fontSize: 30.0,
            //           ),
            //         ),
            //         const Padding(
            //           padding: EdgeInsets.fromLTRB(0, 10.0, 0, 5.0),
            //           child: Text("You have 1 delivery today",
            //           style: TextStyle(
            //               fontSize: 20.0,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            //   Padding( //TODO: Add RecipientTiles
            //     padding: const EdgeInsets.all(5.0),
            //     child: RecipientTile(currentRecipient: exampleRecipient),
            //   ),
            // ],
          );
        }
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff9d2235),
          foregroundColor: Colors.white,
          shadowColor: const Color(0xff545859).withOpacity(0.8),
          elevation: 5.0,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
        ),
        child: const Text("Can't deliver? Let us know!",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        onPressed: () {
          //context.push("/addOrgs").then((_) => setState(() {}));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}