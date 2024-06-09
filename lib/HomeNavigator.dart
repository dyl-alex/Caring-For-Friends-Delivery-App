import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:test/map.dart';
import 'AvailablePage.dart';
import 'HomePage.dart';
import 'SchedulePage.dart';
import 'map.dart';
import 'models/Delivery.dart';
import 'models/Organization.dart';
import 'models/Recipient2.dart';
import 'models/User.dart';
import 'organizationsPage.dart';
import 'globals.dart';
import 'CffApi.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'amplifyconfiguration.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'organizationsPage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    userOrgsLength = getUserOrgsLength();
    _configureCurrentUser();
    getOpenDelivery();
    //updateRecip();
    //readyMapData();

  }

  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  late Future<List<Recipient2>> userRecipients;
  late Future<int> userRecipientsLength;
  late Future<int> userOrgsLength;
  List<Recipient2> recipientData = [];
  List<Delivery> _openDeliveries = [];
  String userID = '';

  void _configureCurrentUser() async {
    try {
      User user = await myAPI.getUserByEmail("dalexander_02@arcadia.edu");
      currentUserId = user.id;
      print(user.id);
      currentUserEmail = user.email;
      currentUserOrgs = user.organizations;

      setState(() {
        userID = user.id;
      });

    }
    on Exception catch (e) {
      safePrint('Error configuring currentUser $e');
    }
  }

  Recipient2 recip = new Recipient2(Id: "649f00dc-00af-44d0-9c60-24c373ef08fe", driverID: "4c55ec32-6872-46e3-a3ef-587b9fc8b7b6", address: "321 Pickle St.", city: "Philadelphia", firstName: "Mary", lastName: "Jones", latitude: "45.333432", longitude: "-75.16592164449011", schedule: "A", notes: "Peanut Allergy", orgId: "7949c301-9766-44f4-8768-76cf22c02cde");
  Recipient2 recip2 = new Recipient2(Id: "d58818f0-0a49-4b2e-8d4d-d6c3c4b79d9d", driverID: "4c55ec32-6872-46e3-a3ef-587b9fc8b7b6", address: "342 tutu ave", city: "Philadelphia", firstName: "Terrance", lastName: "Jones", latitude: "40.150070", longitude: "-75.002480", schedule: "A", notes: "Peanut Allergy", orgId: "7949c301-9766-44f4-8768-76cf22c02cde");
  Recipient2 recip3 = new Recipient2(Id: "23af0c04-063c-4196-b0cf-6adb3e1050aa", driverID: "4c55ec32-6872-46e3-a3ef-587b9fc8b7b6", address: "123 Movie st", city: "Philadelphia", firstName: "Tyler", lastName: "Mui", latitude: "40.101921", longitude: "-74.984589", schedule: "A", notes: "Peanut Allergy", orgId: "7949c301-9766-44f4-8768-76cf22c02cde");
  String timeString = DateTime.now().toIso8601String();
  Delivery deliv = new Delivery(id:  "b87acrt2-173b-33de-9090-357dh5ydn129", recipientId: "d58818f0-0a49-4b2e-8d4d-d6c3c4b79d9d", date:DateTime.now() , driverId: "4c55ec32-6872-46e3-a3ef-587b9fc8b7b6");
  Delivery deliv2 = new Delivery(id: "58en4993-fe53-go3d-79di-fzs93sdhdj23", recipientId: "23af0c04-063c-4196-b0cf-6adb3e1050aa", date:DateTime.now() , driverId: "4c55ec32-6872-46e3-a3ef-587b9fc8b7b6");

  void updateRecip() async
  {
    Delivery devCheck = await myAPI.postDelivery(deliv2);
    print("DevCheck: ${devCheck.id} ${devCheck.driverId} ${devCheck.date} }");
    // Delivery upDev = await myAPI.postDelivery(deliv);
    // print("upDev: ")
    // Delivery updev2 = await myAPI.postDelivery(deliv2);
  }

  void getOpenDelivery() async {
    //currentUserId = await cffApi.getUser(currentUserId).then((value) => value.id);
    List<Delivery> openDeliveries = await myAPI.getAvailableDeliveries();
    _openDeliveries = openDeliveries;
    setState(() {
    });
    for (int i = 0; i < _openDeliveries.length; i++)
    {
      print("Delivery id: ${_openDeliveries[i].id}  Recipient Id: ${_openDeliveries[i].recipientId} Driver ID: ${_openDeliveries[i].driverId} Date: ${_openDeliveries[i].date}");
    }
    setListItems();
  }

  void setListItems() async {
    print("In setListItems!");
    List<Recipient2> tempList = [];
    Recipient2 recipient;
    for (var delivery in _openDeliveries) {
      recipient = await myAPI.getRecipient(delivery.recipientId);
      print(recipient.address);
      tempList.add(recipient);
    }
    setState(() {
      recipientData = tempList;
    });
  }

  Future<List<Organization>> getUserOrgs() async {
    int index = 0;
    myUser = await myAPI.getUser("4c55ec32-6872-46e3-a3ef-587b9fc8b7b6");

    List<dynamic> allOrgIDs = await myUser.getOrganizations();

    List<Organization> userOrgs = [placeHolder];

    for (index; index < allOrgIDs.length; index++) {
      userOrgs.add(await myAPI.getOrganization(allOrgIDs.elementAt(index)));
    }

    userOrgs.removeAt(0);
    for(int i = 0; i < userOrgs.length; i++) {
      print(userOrgs.elementAt(i).organizationName);
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
    print(index);
    //print(myAPI.getUserRecipients("4c55ec32-6872-46e3-a3ef-587b9fc8b7b6"));
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

  void readyMapData () async{
    List<Recipient2> recipientList = await myAPI.getUserRecipients("4c55ec32-6872-46e3-a3ef-587b9fc8b7b6");
    setState(() {
      recipientData = recipientList;
    });
    for(int i = 0; i < recipientData.length; i++)
    {
      print("Id: ${recipientData[i].Id} Driver Id: ${recipientData[i].driverID} address: ${recipientData[i].address} city: ${recipientData[i].city} "
          "first name: ${recipientData[i].firstName} last name: ${recipientData[i].lastName} Schedule: ${recipientData[i].schedule} Notes ${recipientData[i].notes}"
          "ordID: ${recipientData[i].orgId} Lat: ${recipientData[i].latitude} Long: ${recipientData[i].longitude}");
    }
  }

  Widget appBarTitle() {
    switch (_page) {
      case 0:
        return const Text('Home');
        break;
      case 1:
        return const Text('My Schedule');
        break;
      case 2:
        return const Text('Available Deliveries');
        break;
      default:
        return const Text('Map');
        break;
    }
  }

  Widget bodyFunction() {
    switch (_page) {
      case 0:
        return const HomePage();
        break;
      case 1:
        return const SchedulePage();
        break;
      case 2:
        return const AvailablePage();
        break;
      case 3:
      //readyMapData();
        return MapSample(recipientData);
      default:
        return Container(color: Colors.blue);
        break;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 70.0,
          title: appBarTitle(),
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
                  //TODO: Go to profile page or profile sub-page
                  signOutCurrentUser();
                }
            )
          ]
      ),
      body: bodyFunction(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xff545859).withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            child: GNav(
              key: _bottomNavigationKey,
              gap: 10,
              activeColor: const Color(0xff9d2235),
              padding: const EdgeInsets.all(15),
              onTabChange: (index) {
                print(index);
                setState(() {
                  _page = index;
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.calendar_month_outlined,
                  text: 'My Schedule',
                ),
                GButton(
                  icon: Icons.list,
                  text: 'Available Deliveries',
                ),
                GButton(
                  icon: Icons.map,
                  text: 'Map',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}