import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'organizationsPage.dart';
import 'globals.dart';
import 'CffApi.dart';

class AddOrganizations extends StatefulWidget {
  const AddOrganizations({super.key});

  @override
  State<AddOrganizations> createState() => _addOrganizationsState();
}

class _addOrganizationsState extends State<AddOrganizations> {
  final _textController = TextEditingController();

  String orgCodeInput = '';
  bool isValidCode = true;
  bool alreadyRegistered = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0,
        title: const Text("Add Organization"),
        backgroundColor: const Color(0xff9d2235),
        foregroundColor: Colors.white,
        elevation: 5,
        shadowColor: const Color(0xff545859).withOpacity(0.5),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
            child: Text(
              "Enter your organization's join code below:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              keyboardType: TextInputType.number,
              maxLength: 5,
              decoration: InputDecoration(
                hintText: "Organization Code",
                border: const OutlineInputBorder(),
                errorText: isValidCode ? null : "Invalid organization code. Please try again.",
                suffixIcon: IconButton(
                  onPressed: () {
                    _textController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 15.0),
            child: SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff9d2235),
                  foregroundColor: Colors.white,
                  shadowColor: const Color(0xff545859).withOpacity(0.8),
                  elevation: 5.0,
                ),
                onPressed: () {
                  setState(() {
                    orgCodeInput = _textController.text;
                    switch (orgCodeInput) {
                      case '12345':
                        {
                          //TODO: prevent users from adding orgs they already have
                          _showDialog("Caring for Friends");
                          //myUser.allOrganizations.add(org1); //TODO: Add orgs to DynamoDB
                          break;
                        }
                      case '67890':
                        {
                          _showDialog("Chibi Godzilla");
                          //myUser.allOrganizations.add(org2); //TODO: Add orgs to DynamoDB
                          break;
                        }
                      default:
                        {
                          setCodeValidation(false);
                          break;
                        }
                    }
                  });
                },
                child: const Text(
                  "Add to My Organizations",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void setCodeValidation(valid) {
    setState(() {
      isValidCode = valid;
    });
  }

  void setAlreadyRegistered(registered) {
    setState(() {
      alreadyRegistered = registered;
    });
  }

  void _showDialog(String orgName) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Confirm Organization'),
          content: Text('Add "$orgName" to your organizations?'),
          actions: [
            MaterialButton(
              onPressed: () {
                setCodeValidation(true);
                Navigator.pop(context);
                if(isValidCode) {
                  context.pop("/orgsPage");
                }
              },
              child: Text('Add'),
            ),
            MaterialButton(
              onPressed: () {
                _textController.clear();
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            )
          ],
        );
      });
  }
}
