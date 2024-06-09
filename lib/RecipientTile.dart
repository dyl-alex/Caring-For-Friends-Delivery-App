import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'globals.dart';
import 'models/Recipient2.dart';

class RecipientTile extends StatelessWidget {
  const RecipientTile({
    super.key,
    required this.currentRecipient,
  });

  final Recipient2 currentRecipient;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
      title: Text(
        currentRecipient.getFirstName() + " " + currentRecipient.getLastName(),
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      trailing: LiteRollingSwitch(
        value: false,
        textOn: "Delivered",
        textOff: "To-Do",
        colorOn: Colors.blueAccent,
        colorOff: Colors.redAccent,
        iconOn: Icons.done,
        textSize: 15.0,
        onChanged: (bool position) {
          print("The button is $position");
        },
        onTap: () {
          print("Tapped");
        },
        onDoubleTap: () {
          print("Double Tapped");
        },
        onSwipe: () {
          print("Swiped");
        }
      ),
      expandedAlignment: Alignment.topLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          child: Text("Address:",
          textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
          child: Text(currentRecipient.getAddress() + " " + currentRecipient.getCity(),
            style: const TextStyle(
              fontSize: 17.0,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          child: Text("Notes:",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
          child: Text(currentRecipient.getNotes(),
            style: const TextStyle(
              fontSize: 17.0,
            ),
          ),
        ),
      ],
    );
    throw UnimplementedError();
  }
}