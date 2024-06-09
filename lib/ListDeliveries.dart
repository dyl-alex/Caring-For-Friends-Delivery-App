import 'package:flutter/material.dart';
import 'databaseEntry.dart';
import 'package:intl/intl.dart';

class listDel extends StatefulWidget {
  List<Entry>? data;
  listDel(this.data, {super.key});

  @override
  State<listDel> createState() => _listDelState();
}

class _listDelState extends State<listDel> {
  buildBody() {
    return ListView(
      children: [
        for (int i = 0; i < widget.data!.length; i++)
          Center(
            child: ListTile(
              leading: Icon(Icons.house),
              title: Text(
                  "${widget.data![i].address!} \n${widget.data![i].city!} , ${widget.data![i].state!} ${widget.data![i].zip}"),
              subtitle: Text(widget.data![i].deliverer!),
              trailing: widget.data![i].confirmDelivery![0]
                  ? Text(
                      "Not Delivered",
                      style: TextStyle(color: Colors.red),
                    )
                  : Text("Delivery Confirmed"),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.data!.isEmpty
        ? const Center(child: Text("No Delivery in List"))
        : buildBody();
  }
}
