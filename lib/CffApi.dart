import 'dart:convert';

import 'package:test/authFunctions.dart';
import 'package:test/globals.dart';

import 'models/Delivery.dart';
import 'models/Organization.dart';
import 'models/User.dart';
import 'package:http/http.dart' as http;
import 'models/Recipient2.dart';

class CffApi {
  final request = {
    'headers': {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    'body': {

    }
  };
  //User
  Future<User> getUser(String userId) async {
    final response = await http.get(
      Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/user?Id=$userId'),
      headers:<String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken
      }
    );
    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);

      User user = User.fromJson(json as Map<String, dynamic>);
      return user;
    } else {
      throw Exception('Failed to create album. Status code: ${response.body}');
    }
  }

  Future<User> getUserByEmail(String email) async {
    final response = await http.get(
        Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/user/byEmail?Email=$email'),
        headers:<String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': accessToken
        }
    );
    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);

      User user = User.fromJson(json as Map<String, dynamic>);
      return user;
    } else {
      throw Exception('Failed to create album. Status code: ${response.body}');
    }
  }
  //Recipient
  Future<Recipient2> postRecipient(Recipient2 recipient) async{
    final json = jsonEncode(recipient.toJson());
    final response = await http.post(
      Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/recipient'),
        headers:<String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': accessToken
        },
      body: json
    );
    if (response.statusCode == 200) {
      return recipient;
    } else {
      print(response.statusCode);
      throw Exception(response.body);
    }
  }

  Future<Recipient2> updateRecipient(Recipient2 recipient) async{
    final json = jsonEncode(recipient.toJson());
    final response = await http.patch(
        Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/recipient'),
        headers:<String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': accessToken
        },
        body: json
    );
    if (response.statusCode == 200) {
      return recipient;
    } else {
      print(response.statusCode);
      throw Exception(response.body);
    }
  }

  Future<Recipient2> getRecipient(String recipientId) async {
    final response = await http.get(
      Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/recipient?RecipientId=${recipientId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken
      },
    );
    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);
      Recipient2 recipient = Recipient2.fromJson(json as Map<String, dynamic>);

      return recipient;
    } else {
      throw Exception(
          'Failed to create album. Status code: ${response.statusCode}'
      );
    }
  }

  Future<String> deleteRecipient(String recipientId) async {
    final response = await http.delete(
      Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/recipient?RecipientId=${recipientId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken
      },
    );
    if (response.statusCode == 200) {
      return "Succesfully deleted recipient with Id " + recipientId;
    } else {
      throw Exception(
          'Could not remove recipient: ${response.statusCode}'
      );
    }
  }
  //UserRecipients
  Future<List<Recipient2>> getUserRecipients(String userId) async {
    final response = await http.get(
      Uri.parse(
          'https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/userRecipients?UserId=$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken
      },
    );

    if (response.statusCode == 200) {
      // Parse the JSON list
      List<dynamic> jsonList = jsonDecode(response.body);
      // Create a list to store recipients
      List<Recipient2> recipients = [];
      // Iterate through each item in the JSON list
      for (var item in jsonList) {
        // Create a Recipient from the current item
        Recipient2 recipient = Recipient2.fromJson(item as Map<String, dynamic>);
        // Add the recipient to the list
        recipients.add(recipient);
      }

      // Print the list of recipients
      recipients.forEach((recipient) {
        //print('Recipient Name: ${recipient.firstName}, Driver ID: ${recipient.driverID}');
        // Add other recipient properties as needed
      });

      // Return the list of recipients
      return recipients;
    } else {
      throw Exception(
          'Failed to create album. Status code: ${response.statusCode}');
    }
  }


  //Organizations
  Future<Organization> postOrganization(Organization organization) async {
    final json = jsonEncode(organization.toJson());
    final response = await http.post(
        Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/organization'),
        headers:<String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': accessToken
        },
        body: json
    );
    if (response.statusCode == 200) {
      return organization;
    } else {
      print(response.statusCode);
      throw Exception(response.body);
    }
  }

  Future<Organization> getOrganization(String organizationId) async {
    final response = await http.get(
      Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/organization?OrganizationId=${organizationId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken,
    },
    );
    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);
      Organization organization = Organization.fromJson(json as Map<String, dynamic>);

      return organization;
    } else {
      throw Exception(
        'Failed to create album. Status code: ${response.statusCode} + Body: ${response.body}'
      );
    }
  }

  Future<Organization> updateOrganization(Organization organization) async {
    final json = jsonEncode(organization.toJson());
    final response = await http.patch(
        Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/organization'),
        headers:<String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': accessToken
        },
        body: json
    );
    if (response.statusCode == 200) {
      return organization;
    } else {
      print(response.statusCode);
      throw Exception(response.body);
    }
  }

  Future<String> deleteOrganization(String organizationId) async {
    final response = await http.delete(
      Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/organization?OrganizationId=${organizationId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken
      },
    );
    if (response.statusCode == 200) {
      return "Succesfully deleted recipient with Id " + organizationId;
    } else {
      throw Exception(
          'Could not remove recipient: ${response.statusCode}'
      );
    }
  }

  //Organizations
  Future<List<Organization>> getOrganizations() async {
    final response = await http.get(
      Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/organizations'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken
      }
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);

      List<Organization> organizations = [];
      for (var item in jsonList) {
        Organization organization = Organization.fromJson(item as Map<String, dynamic>);

        organizations.add(organization);
      }
      print(jsonDecode(response.body));
      return organizations;
    } else {
      throw Exception(
          'Failed to create album. Status code: ${response.statusCode}');
    }
  }

  //get User Organizations
  Future<List<dynamic>> getUserOrganizations(String userId) async {
    final response = await http.get(
        Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/user?Id=$userId'),
        headers:<String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': accessToken
        }
    );
    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);

      User user = User.fromJson(json as Map<String, dynamic>);
      //print(user.getOrganizations());
      List<dynamic> orgList = user.getOrganizations();
      print(orgList);

      return orgList;
    } else {
      throw Exception('Failed to create album. Status code: ${response.body}');
    }
  }

  Future<String> getOrganizationName(String organizationId) async {
    final response = await http.get(
      Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/organization?OrganizationId=${organizationId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken
      },
    );
    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);
      Organization organization = Organization.fromJson(json as Map<String, dynamic>);

      return organization.getOrgName();
    } else {
      throw Exception(
          'Failed to create album. Status code: ${response.statusCode}'
      );
    }
  }
  //userDelivery
  Future<List<Delivery>> getUserDelivery(String driverId) async {
    final response = await http.get(
      Uri.parse(
          'https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/userDelivery?UserId=$driverId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<Delivery> deliveries = [];

      for (var item in jsonList) {
        Delivery delivery = Delivery.fromJson(item as Map<String, dynamic>);
        deliveries.add(delivery);
      }

      deliveries.forEach((delivery) {
        print(
            'DriverId: ${delivery.driverId}, RecipientId: ${delivery.recipientId}');
        // Add other recipient properties as needed
      });

      return deliveries;
    } else {
      print("failed");
      throw Exception(
          'Failed to create album. Status code: ${response.statusCode}' ' Body: ${response.body}');
    }
  }

  Future<List<Delivery>> getUserDeliveryByDate(String driverId, String date) async {
    final response = await http.get(
      Uri.parse(
          'https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/userDelivery?UserId=$driverId&Date=$date'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<Delivery> deliveries = [];

      for (var item in jsonList) {
        Delivery delivery = Delivery.fromJson(item as Map<String, dynamic>);
        deliveries.add(delivery);
      }

      deliveries.forEach((delivery) {
        print(
            'DriverId: ${delivery.driverId}, RecipientId: ${delivery.recipientId}');
        // Add other recipient properties as needed
      });

      return deliveries;
    } else {
      print("failed");
      throw Exception(
          'Failed to create album. Status code: ${response.statusCode}' ' Body: ${response.body}');
    }
  }

  Future<List<int>> getUserDeliveryDates(String driverId, String startDate, String endDate) async {
    final response = await http.get(
      Uri.parse(
          'https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/userDelivery?UserId=$driverId&StartDate=$startDate&EndDate=$endDate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken
      },
    );

    if (response.statusCode == 200) {
      List<int> jsonList = jsonDecode(response.body);
      print(jsonList);
      return jsonList;
    } else {
      print("failed");
      throw Exception(
          'Failed to create album. Status code: ${response.statusCode}' ' Body: ${response.body}');
    }
  }
  //Delivery
  Future<Delivery> postDelivery(Delivery delivery) async {
    final json = jsonEncode(delivery.toJson());
    final response = await http.post(
        Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/organization'),
        headers:<String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': accessToken
        },
        body: json
    );
    if (response.statusCode == 200) {
      return delivery;
    } else {
      print(response.statusCode);
      throw Exception(response.body);
    }
  }

  Future<Delivery> getDelivery(String deliveryId) async {
    final response = await http.get(
      Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/organization?Id=${deliveryId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken,
      },
    );
    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);
      Delivery delivery = Delivery.fromJson(json as Map<String, dynamic>);

      return delivery;
    } else {
      throw Exception(
          'Failed to create album. Status code: ${response.statusCode} + Body: ${response.body}'
      );
    }
  }

  Future<List<Delivery>> getAvailableDeliveries() async {
    final response = await http.get(
      Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/delivery/getAvailable'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken,
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<Delivery> deliveries = [];

      for (var item in jsonList) {
        Delivery delivery = Delivery.fromJson(item as Map<String, dynamic>);
        deliveries.add(delivery);
      }

      return deliveries;

    } else {
      throw Exception(
          'Failed to create album. Status code: ${response.statusCode} + Body: ${response.body}'
      );
    }
  }

  Future<Delivery> updateDelivery(Delivery delivery) async {
    final json = jsonEncode(delivery.toJson());
    print(json);
    final response = await http.patch(
        Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/delivery'),
        headers:<String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': accessToken
        },
        body: json
    );
    if (response.statusCode == 200) {
      return delivery;
    } else {
      throw Exception(response.body);
    }
  }

  Future<String> deleteDelivery(String deliveryId) async {
    final response = await http.delete(
      Uri.parse('https://6kg6qxk4n8.execute-api.us-east-2.amazonaws.com/prod/delivery?Id=${deliveryId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken
      },
    );
    if (response.statusCode == 200) {
      return "Succesfully deleted delivery with Id " + deliveryId;
    } else {
      throw Exception(
          'Could not remove recipient: ${response.statusCode}'
      );
    }
  }
}