//import 'dart:io';
//import 'dart:js';

import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test/SchedulePage.dart';
import 'package:test/authFunctions.dart';
import 'package:test/map.dart';
//import 'package:test/Organization_Original.dart';
import 'package:test/practice.dart';
//import 'package:test/databaseEntry.dart';
//import 'package:test/listDeliveries.dart';
//import 'package:test/searchDeliveries.dart';
import 'HomeNavigator.dart';
import 'models/User.dart';
import 'amplifyconfiguration.dart';
//import 'listRecipients.dart';
//import 'map.dart';
//import 'package:csv/csv.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'searchDeliveries.dart';
//import 'searchRecipients.dart';
//import 'confirmDeliveries.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'CffApi.dart';
import 'models/Organization.dart';
import 'models/Recipient2.dart';
import 'organizationsPage.dart';
import 'addOrganizations.dart';
import 'globals.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SqliteApp());
}

class SqliteApp extends StatefulWidget {
  const SqliteApp({super.key});

  @override
  State<SqliteApp> createState() => _SqliteAppState();
}

class _SqliteAppState extends State<SqliteApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  CffApi cffApi = CffApi();

  @override
  void dispose() {
    super.dispose();
  }

  void _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
      safePrint('Successfully configured');
      fetchCognitoAuthSession();
    } on Exception catch (e) {
      safePrint('Error configuring Amplify: $e');
    }
  }

  void _configureCurrentUser() async {
    try {
      User user = await cffApi.getUserByEmail("");
      print(user);
      currentUserId = user.id;
      currentUserEmail = user.email;
      currentUserOrgs = user.organizations;
    } on Exception catch (e) {
      safePrint('Error configuring currentUser $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      signUpForm: SignUpForm.custom(
        fields: [
          SignUpFormField.username(),
          SignUpFormField.password(),
          SignUpFormField.passwordConfirmation(),
          SignUpFormField.custom(
              title: 'First Name',
              attributeKey: CognitoUserAttributeKey.givenName,
              required: true),
          SignUpFormField.custom(
              title: 'Last Name',
              attributeKey: CognitoUserAttributeKey.familyName,
              required: true),
          SignUpFormField.custom(
              title: 'Phone Number',
              attributeKey: CognitoUserAttributeKey.phoneNumber,
              required: true)
        ],
      ),
      initialStep: AuthenticatorStep.signIn,
      child: MaterialApp.router(
        builder: Authenticator.builder(),
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
      ),
    );
  }

  final GoRouter _router = GoRouter(initialLocation: "/orgsPage", routes: [
    GoRoute(
      path: "/orgsPage",
      builder: ((context, state) => const OrganizationsPage()),
    ),
    GoRoute(
        path: "/addOrgs",
        builder: ((context, state) => const AddOrganizations())),
    GoRoute(
        path: "/schedule", builder: ((context, state) => const SchedulePage())),
    GoRoute(path: "/home", builder: ((context, state) => const Home())),
  ]);
}
