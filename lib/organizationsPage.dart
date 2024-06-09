import 'dart:convert';
import 'authFunctions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'Organization_Original.dart';
import 'OrganizationButton.dart';
import 'models/Organization.dart';
import 'models/User.dart';
import 'addOrganizations.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'amplifyconfiguration.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:http/http.dart' as http;
import 'package:google_nav_bar/google_nav_bar.dart';
import 'globals.dart';
import 'CffApi.dart';

class OrganizationsPage extends StatefulWidget {
  const OrganizationsPage({super.key});

  @override
  State<OrganizationsPage> createState() => _OrgPageState();
}

class _OrgPageState extends State<OrganizationsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userOrgsLength = getUserOrgsLength();
    userOrgs = getUserOrgs();
  }
  @override
  void dispose() {
    super.dispose();
  }

  late Future<List<Organization>> userOrgs;
  late Future<int> userOrgsLength;


  Future<List<Organization>> getUserOrgs() async {
    int index = 0;
    myUser = await myAPI.getUser("4c55ec32-6872-46e3-a3ef-587b9fc8b7b6");
    print(myUser);
    List<dynamic> allOrgIDs = await myUser.getOrganizations();

    List<Organization> userOrgs = [placeHolder];

    for (index; index < allOrgIDs.length; index++) {
      userOrgs.add(await myAPI.getOrganization(allOrgIDs.elementAt(index)));
    }

    userOrgs.removeAt(0);
    for(int i = 0; i < userOrgs.length; i++) {
      //print(userOrgs.elementAt(i).organizationName);
    }
    return userOrgs;
  }

  Future<int> getUserOrgsLength() async {
    int index = 0;
    myUser = await myAPI.getUser("4c55ec32-6872-46e3-a3ef-587b9fc8b7b6");
    List<Organization> userOrgs = [placeHolder];
    while (index < myUser.getOrganizations().length){
      index++;
    }
    return index;
  }

  Future<void> signOutCurrentUser() async {
    final result = await Amplify.Auth.signOut();
    if (result is CognitoCompleteSignOut) {
      safePrint('Sign out completed successfully');
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 70.0,
          title: const Text('Organizations'),
          backgroundColor: const Color(0xff9d2235),
          foregroundColor: Colors.white,
          elevation: 5,
          shadowColor: const Color(0xff545859).withOpacity(0.5),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: "My Profile",
              onPressed: () {
                //TODO: Go to profile page
                signOutCurrentUser();
              },
            ),
          ]),
      body: FutureBuilder(
        future: Future.wait([userOrgs, userOrgsLength]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          List<Widget> children = [];
          if (snapshot.hasData) {
            children = <Widget> [
              for (int index = 0; index < snapshot.data?[1]; index++) //TODO: register user + their orgs
                OrganizationButton(organization: snapshot.data?[0][index]),
            ];
          }
          else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  CircularProgressIndicator(
                    semanticsLabel: "Loading Organizations",
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                    child: Text("Loading Organizations..."),
                  ),
                ],
              ),
            );
          }
          return GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 20.0,
            padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 25.0),
            children: children,
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
          padding: const EdgeInsets.fromLTRB(130, 20, 130, 20),
        ),
        child: const Text("Add Organization"),
        onPressed: () {
          context.push("/addOrgs").then((_) => setState(() {}));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
