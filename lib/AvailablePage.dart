import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CffApi.dart';
import 'globals.dart';
import 'models/Delivery.dart';
import 'models/Recipient2.dart';

class AvailablePage extends StatefulWidget {
  const AvailablePage({super.key});
  @override
  State<AvailablePage> createState() => _AvailablePageState();
}

class _AvailablePageState extends State<AvailablePage> {

  CffApi cffApi = CffApi();
  List<Recipient2> listItems = [];
  List<Delivery> _openDeliveries = [];

  @override
  void initState() {
    super.initState();
    getOpenDelivery();
  }

  void getOpenDelivery() async {
    //currentUserId = await cffApi.getUser(currentUserId).then((value) => value.id);
    List<Delivery> openDeliveries = await cffApi.getAvailableDeliveries();
    setState(() {
      _openDeliveries = openDeliveries;
    });
    for (int i = 0; i < _openDeliveries.length; i++)
      {
        print(_openDeliveries[i].date);
      }
    setListItems();
  }

  void updateOpenDeliveries() async {
    List<Delivery> openDeliveries = await cffApi.getAvailableDeliveries();
    setState(() {
      _openDeliveries = openDeliveries;
    });
    setListItems();
  }

  void pickUpDelivery(int deliveryIndex) async {
    print(_openDeliveries[deliveryIndex].date);
    cffApi.updateDelivery(
        Delivery(
          id: _openDeliveries[deliveryIndex].id,
          recipientId: _openDeliveries[deliveryIndex].recipientId,
          date: _openDeliveries[deliveryIndex].date,
          driverId: currentUserId,
        )
    );
    updateOpenDeliveries();
  }

  void setListItems() async {
    List<Recipient2> tempList = [];
    Recipient2 recipient;
    for (var delivery in _openDeliveries) {
      recipient = await cffApi.getRecipient(delivery.recipientId);
      tempList.add(recipient);
    }
    setState(() {
      listItems = tempList;
    });
    print(listItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
            itemCount: listItems.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
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
                      child: const Text('Pick Up Delivery'),
                      onPressed: () {
                        pickUpDelivery(index);
                      },
                    )],
                )
              ));
            }
        )
      )
    );
  }
}

