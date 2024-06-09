library globals;

import 'CffApi.dart';
import 'models/Organization.dart';
import 'models/Recipient2.dart';
import 'models/User.dart';
import 'Organization_Original.dart';

CffApi myAPI = CffApi();

Organization placeHolder = Organization(organizationId: 'n/a', organizationName: 'n/a', icon: 'n/a', thumbnail: 'n/a', joinCode: 'n/a');
User currentUser = User(id: 'id', firstName: 'firstName', email: 'email', lastName: 'lastName', organizations: ['organizations'], phoneNumber: 'phoneNumber', isVerified: true, role: 'role');
String currentUserEmail = "";
String currentUserId = "";
List<dynamic> currentUserOrgs = [];
String accessToken = "";

Recipient2 exampleRecipient = const Recipient2(Id: "1234", driverID: "5678", address: "567 My Street Rd", city: "MyCity, PA", firstName: "Alyssa", lastName: "Quisito", latitude: "000", longitude: "111", schedule: "A", notes: "No tomatoes!", orgId: "0987");

late User myUser;
late Organization currentOrg;