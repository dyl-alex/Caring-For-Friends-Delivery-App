import 'package:flutter/material.dart';
import 'databaseEntry.dart';

class listRec extends StatefulWidget {
  List<Entry>? data;
  listRec(this.data, {super.key});

  @override
  State<listRec> createState() => _listRecState();
}

class _listRecState extends State<listRec> {
  buildBody() {
    return ListView(
      children: [
        for (int i = 0; i < widget.data!.length; i++)
          Center(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Column(
                children: [
                  Text(widget.data![i].recipientLast! +
                      ", " +
                      widget.data![i].recipientFirst! +
                      ''),
                  schedule(widget.data![i].schedule!),
                ],
              ),
              subtitle: Column(
                children: [Text(widget.data![i].deliverer!)],
              ),
              trailing: Text(widget.data![i].cell!),
            ),
          )
      ],
    );
  }

  schedule(int i) {
    String text = "";
    switch (i) {
      case 1:
        text = "First & Third Friday";
        break;
      case 2:
        text = "Second & Fourth Friday";
        break;
      case 3:
        text = "First Monday";
        break;
      case 4:
        text = "Third Wednesday";
        break;
    }
    return Text(text);
  }

  @override
  Widget build(BuildContext context) {
    return widget.data!.isEmpty
        ? Center(child: Text("No Delivery in List"))
        : buildBody();
  }
}
