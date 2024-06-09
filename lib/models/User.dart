import 'package:test/Organization_Original.dart';

class User {

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final bool isVerified;
  final List<dynamic> organizations;
  final String phoneNumber;
  final String role;

  const User({
    required this.id,
    required this.firstName,
    required this.email,
    required this.lastName,
    required this.organizations,
    required this.phoneNumber,
    required this.isVerified,
    required this.role
});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['Id'] as String,
      firstName: json['FirstName'] as String,
      lastName: json['LastName'] as String,
      email: json['Email'] as String,
      isVerified: json['IsVerified'] as bool,
      role: json['Role'] as String,
      phoneNumber: json['PhoneNumber'] as String,
      organizations: json['Organizations'] as List<dynamic>
    );
  }

  getID() {
    return id;
  }

  getOrganizations(){
    return organizations;
  }

  getOrganization(int index) {
    return organizations.elementAt(index);
  }
}
