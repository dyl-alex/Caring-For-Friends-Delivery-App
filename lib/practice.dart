import 'dart:convert';

import 'package:flutter/material.dart';
import 'Organization_Original.dart';
import 'OrganizationButton.dart';
import 'models/User.dart';
import 'addOrganizations.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'amplifyconfiguration.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:http/http.dart' as http;
//
// class PracticeRoute extends StatefulWidget {
//   const PracticeRoute({super.key});
//
//   @override
//   State<PracticeRoute> createState() => _practiceRouteState();
// }
//
// class _practiceRouteState extends State<PracticeRoute> {
//
//   static Organization org1 = Organization(orgID: '1', orgName: 'Caring for Friends', orgIcon: 'https://pub-9c53a340c75f4006b5b4d610373cae64.r2.dev/caring_for_friends_icon.svg', orgThumbnail: 'https://pub-9c53a340c75f4006b5b4d610373cae64.r2.dev/caring_for_friends_thumbnail.svg');
//   static Organization org2 = Organization(orgID: '2', orgName: 'Chibi Godzilla', orgIcon: 'https://pub-9c53a340c75f4006b5b4d610373cae64.r2.dev/chibi_godzilla_icon.svg', orgThumbnail: 'https://pub-9c53a340c75f4006b5b4d610373cae64.r2.dev/chibi_godzilla_thumbnail.svg');
//
//   User myUser = User(userID: '01', email: 'aquisito@arcadia.edu', firstName: 'Alyssa', lastName: 'Quisito', phoneNumber: '2673465211', roleID: '1', allOrganizations: [org1, org2]);
//
//   Future<void> signOutCurrentUser() async {
//     final result = await Amplify.Auth.signOut();
//     if (result is CognitoCompleteSignOut) {
//       safePrint('Sign out completed successfully');
//     } else if (result is CognitoFailedSignOut) {
//       safePrint('Error signing user out: ${result.exception.message}');
//     }
//   }
//
//   Future<List<Recipient>> createAlbum(String title) async {
//     final response = await http.get(
//       Uri.parse(
//           'https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/userRecipients?DriverId=bf487144-7424-11ee-b962-0242ac120002'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       // Parse the JSON list
//       List<dynamic> jsonList = jsonDecode(response.body);
//
//       // Create a list to store recipients
//       List<Recipient> recipients = [];
//
//       // Iterate through each item in the JSON list
//       for (var item in jsonList) {
//         // Create a Recipient from the current item
//         print(item);
//         Recipient recipient = Recipient.fromJson(item as Map<String, dynamic>);
//
//         // Add the recipient to the list
//         recipients.add(recipient);
//       }
//
//       // Print the list of recipients
//       print('List of Recipients:');
//       recipients.forEach((recipient) {
//         print(
//             'Recipient Name: ${recipient.firstName}, Driver ID: ${recipient.driverID}');
//         // Add other recipient properties as needed
//       });
//
//       // Return the list of recipients
//       return recipients;
//     } else {
//       throw Exception(
//           'Failed to create album. Status code: ${response.statusCode}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           toolbarHeight: 70.0,
//           title: const Text('Organizations'),
//           centerTitle: true,
//           actions: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.person),
//               tooltip: "My Profile",
//               onPressed: () {
//                 //TODO: Go to profile page
//                 signOutCurrentUser();
//                 //createAlbum('recipients');
//               },
//             )
//           ]),
//       body: GridView.count(
//         crossAxisCount: 2,
//         mainAxisSpacing: 20.0,
//         crossAxisSpacing: 20.0,
//         padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 25.0),
//         children: [OrganizationButton(organization: org1),
//           OrganizationButton(organization: org2),
//         ],
//       ),
//       floatingActionButton: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15)),
//           padding: const EdgeInsets.fromLTRB(130, 20, 130, 20),
//         ),
//         child: const Text("Add Organization"),
//         onPressed: () {
//           Navigator.pushNamed(context, '/addOrgs');
//           //TODO: Go to 'Add organizations' page
//         },
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       bottomNavigationBar: BottomAppBar(
//         color: Colors.blue,
//         child: Container(
//           height: 55,
//         ),
//       ),
//     );
//   }
// }
//
// class Recipient {
//   //final String recipientID;
//   final String driverID;
//   final String address;
//   final String city;
//   final String firstName;
//   final String lastName;
//   //final String latitude;
//   // final String longitude;
//   //final String schedule;
//   //final String notes;
//
//   const Recipient({
//     /*required this.recipientID,*/ required this.driverID,
//     required this.address,
//     required this.city,
//     required this.firstName,
//     required this.lastName,
//     /*required this.latitude, required this.longitude, required this.schedule, required this.notes*/
//   });
//
//   factory Recipient.fromJson(Map<String, dynamic> json) {
//     return Recipient(
//       //recipientID: json['id'] as String,
//       driverID: json['DriverId'] as String,
//       address: json['Address'] as String,
//       city: json['City'] as String,
//       firstName: json['FirstName'] as String,
//       lastName: json['LastName'] as String,
//       //latitude: json[''] as String,
//       //longitude: json[''] as String,
//       //schedule: json['Schedule'] as String,
//       //notes: json[''] as String,
//     );
//   }
// }
