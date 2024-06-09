import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:test/models/Recipient2.dart';
import 'package:url_launcher/url_launcher.dart';

import 'globals.dart';

Future<void> fetchCognitoAuthSession() async {
  try {
    final cognitoPlugin = Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
    final result = await cognitoPlugin.fetchAuthSession();
    final identityId = result.userPoolTokensResult.value.idToken.userId;
    final email = result.userPoolTokensResult.value.signInMethod;

    fetchUserAttributes();

    accessToken = result.userPoolTokensResult.value.idToken.raw;
  } on AuthException catch (e) {
    safePrint("Error retrieving auth session: ${e.message}");
  }
}

Future<String> fetchCognitoAccessToken() async {
  final cognitoPlugin = Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
  final result = await cognitoPlugin.fetchAuthSession();
  return result.userPoolTokensResult.value.idToken.userId;
}

Future<void> fetchUserAttributes() async {
  final attributes = await Amplify.Auth.fetchUserAttributes();
  currentUserEmail = attributes[6].value;
}

void openGoogleMaps(List<Recipient2> addresses) async {
  if (addresses.isEmpty) {
    print('No addresses provided.');
    return;
  }

  String origin = '${addresses.first.latitude},${addresses.first.longitude}';
  String destination = '${addresses.last.latitude},${addresses.last.longitude}';
  print(addresses);

  List<String> waypoints = [];
  for (int i = 1; i < addresses.length - 1; i++) {
    print(
        "Adding lat: ${addresses[i].latitude} and long: ${addresses[i].longitude}");
    waypoints.add('${addresses[i].latitude},${addresses[i].longitude}');
  }

  String waypointsQuery = waypoints.join('|');

  final Uri googleMapsUrl = Uri.parse("");

  if (await canLaunchUrl(googleMapsUrl)) {
    await launchUrl(googleMapsUrl);
  } else {
    throw 'Could not open Google Maps.';
  }
}
