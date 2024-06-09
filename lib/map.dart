import "dart:async";
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:csv/csv.dart';
import 'package:test/authFunctions.dart';
import 'dart:io';
import 'databaseEntry.dart';
import 'CffApi.dart';
import 'globals.dart';
import 'models/Delivery.dart';
import 'models/Recipient2.dart';
import 'package:geocoding/geocoding.dart';

import 'models/User.dart';

class MapSample extends StatefulWidget {
  List<Recipient2> data;
  //List<Map<String, double>> locationList ;
  MapSample(this.data, {super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  @override
  void initState() {
    super.initState();

    if (widget.data.isNotEmpty) {
      initialCameraPosition = LatLng(double.parse(widget.data[0].latitude),
          double.parse(widget.data[0].longitude));
    }
  }

  LatLng? initialCameraPosition;
  List<String> addressList = [];
  List<Map<String, double>> locationList = [];
  String? mapStyle;
  Set<Marker> markerSet = {};
  List<Recipient2> recipientData = [];
  List<Delivery> userDeliveries = [];
  String userID = '';

  void _configureCurrentUser() async {
    try {
      User user = await myAPI.getUserByEmail("");
      print(user);
      currentUserId = user.id;
      currentUserEmail = user.email;
      currentUserOrgs = user.organizations;

      setState(() {
        userID = user.id;
      });
    } on Exception catch (e) {
      safePrint('Error configuring currentUser $e');
    }
  }

  void getUserDelivery() async {
    currentUserId =
        await myAPI.getUser(currentUserId).then((value) => value.id);
    List<Delivery> userDeliveries = await myAPI.getUserDeliveryByDate(
        currentUserId, DateTime.now().toIso8601String());
    setState(() {
      userDeliveries = userDeliveries;
    });
    setListItems();
  }

  void setListItems() async {
    print("In setListItems!");
    List<Recipient2> tempList = [];
    Recipient2 recipient;
    for (var delivery in userDeliveries) {
      recipient = await myAPI.getRecipient(delivery.recipientId);
      tempList.add(recipient);
    }
    setState(() {
      recipientData = tempList;
    });

    print("Recipient Data: $recipientData");
  }

  Set<Marker> genMarkers() {
    if (markerSet.isNotEmpty) return markerSet;
    var data = widget.data;
    Set<Marker> testSet = {};
    // testSet.add(Marker(markerId: MarkerId("HELLOO"), position: LatLng(40.0920, -75.1652)));
    // testSet.add(Marker(markerId: MarkerId("HELLOO2"), position: LatLng(40.0920, -71.1652)));
    int ListLen = data.length;
    print("Length of list: $ListLen");
    for (int i = 0; i < 3; i++) {
      print("adding API markers!");
      testSet.add(Marker(
          markerId: MarkerId(data[i].driverID),
          position: LatLng(double.parse(data[i].latitude),
              double.parse(data[i].longitude))));
      print("Current Entries: $testSet");
    }
    markerSet = testSet;
    print(markerSet);
    return markerSet;
  }

  void getMapStyle() async {
    final rawdata =
        await DefaultAssetBundle.of(context).loadString("assets/map_style.txt");
    setState(() {
      mapStyle = rawdata;
    });
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(45.333432, -75.16592164449011),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    getMapStyle();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: initialCameraPosition ??
                  LatLng(45.333432, -75.16592164449011),
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) async {
              print("map Created!");
              _controller.complete(controller);
              controller.setMapStyle(mapStyle);
            },
            markers: makeMarker(),
          ),
          Positioned(
              child: ElevatedButton(
            child: Text("Get Route"),
            onPressed: () {
              openGoogleMaps(widget.data);
            },
          ))
        ],
      ),
    );
  }

  Set<Marker> makeMarker() {
    if (markerSet.isNotEmpty) return markerSet;
    //sets the 'MapStyle' String to the map_style.txt so that default location markers are hidden
    var data = widget.data;
    Set<Marker> markers = <Marker>{};
    markers.clear();
    for (int i = 0; i < data.length; i++) {
      print("Making Marker");
      Marker m = Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(
              double.parse(data[i].latitude), double.parse(data[i].longitude)!),
          infoWindow: InfoWindow(
            title: "${data[i].firstName} ${data[i].lastName!}",
            snippet: "${data[i].address!} ${data[i].city!},",
          ));
      markers.add(m);
      print(data[i].address);
    }
    setState(() {
      markerSet = markers;
    });
    return markers;
  }
}
