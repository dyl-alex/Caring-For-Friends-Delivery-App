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

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  @override
  State<SchedulePage> createState() => _schedulePageState();
  }

class _schedulePageState extends State<SchedulePage> {
  @override
  void initState() {
    super.initState();
    _configureCurrentUser();
    getUserDelivery();

  }

  CffApi cffApi = CffApi();
  late Future<List<Delivery>> userDeliveries;
  List<Delivery> _userDeliveries = [];
  List<Recipient2> listItems = [];
  String userId = "";

  void getUserDelivery() async {
    currentUserId = await cffApi.getUser(currentUserId).then((value) => value.id);
    List<Delivery> userDeliveries = await cffApi.getUserDeliveryByDate(currentUserId, DateTime.now().toIso8601String());
    setState(() {
      _userDeliveries = userDeliveries;
    });
    setListItems();
  }

  void updateUserDeliveries(DateTime datePicked) async {
    List<Delivery> userDeliveries = await cffApi.getUserDeliveryByDate(currentUserId, datePicked.toIso8601String());
    setState(() {
      _userDeliveries = userDeliveries;
    });
    setListItems();
  }

  void dropDelivery(int deliveryIndex) async {
    print(_userDeliveries[deliveryIndex].date);
    cffApi.updateDelivery(
      Delivery(
        id: _userDeliveries[deliveryIndex].id,
        recipientId: _userDeliveries[deliveryIndex].recipientId,
        date: _userDeliveries[deliveryIndex].date,
        driverId: 'Available',
      )
    );
    getUserDelivery();
  }

  void _configureCurrentUser() async {
    try {
      User user = await cffApi.getUserByEmail("dalexander_02@arcadia.edu");
      print(user);
      currentUserId = user.id;
      currentUserEmail = user.email;
      currentUserOrgs = user.organizations;

      setState(() {
        userId = user.id;
      });

    }
    on Exception catch (e) {
      safePrint('Error configuring currentUser $e');
    }
  }

  void setListItems() async {
    List<Recipient2> tempList = [];
    Recipient2 recipient;
    for (var delivery in _userDeliveries) {
      recipient = await cffApi.getRecipient(delivery.recipientId);
      tempList.add(recipient);
    }
    setState(() {
      listItems = tempList;
    });
    print(listItems);
  }
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget> [
          Container(
            padding: const EdgeInsets.all(10),
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
              onDateChanged: (DateTime value) {
                updateUserDeliveries(value);
              },
            ),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: listItems.length,
            itemBuilder: (context, index) {
              return Card(child: ListTile(
                leading: CircleAvatar(child: Text(listItems[index].firstName.substring(0,1))),
                title: Text("${listItems[index].firstName} ${listItems[index].lastName}"),
                subtitle: Text("Address: ${listItems[index].address}"),
                trailing: MenuAnchor(
                  builder: (BuildContext context, MenuController controller, Widget? child) {
                    return IconButton(
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        icon: const Icon(Icons.more_vert));
                  },
                  menuChildren: [
                    MenuItemButton(
                      child: const Text('Drop Delivery'),
                      onPressed: () {
                        dropDelivery(index);
                    },
                  )],
                )
                )
              );
              },
          )
        ]
      ),
    );
  }
}