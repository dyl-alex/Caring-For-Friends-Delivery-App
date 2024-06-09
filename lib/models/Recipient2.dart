class Recipient2 {
  final String Id;
  final String driverID;
  final String address;
  final String city;
  final String firstName;
  final String lastName;
  final String latitude;
  final String longitude;
  final String schedule;
  final String notes;
  final String orgId;

  const Recipient2({
    required this.Id,
    required this.driverID,
    required this.address,
    required this.city,
    required this.firstName,
    required this.lastName,
    required this.latitude,
    required this.longitude,
    required this.schedule,
    required this.notes,
    required this.orgId
  });

  factory Recipient2.fromJson(Map<String, dynamic> json) {
    return Recipient2(
      Id: json['Id'] as String,
      driverID: json['DriverId'] as String,
      address: json['Address'] as String,
      city: json['City'] as String,
      firstName: json['FirstName'] as String,
      lastName: json['LastName'] as String,
      latitude: json['Latitude'] as String,
      longitude: json['Longitude'] as String,
      schedule: json['Schedule'] as String,
      notes: json['Notes'] as String,
      orgId: json['OrgId'] as String
    );
  }
  Map<String, dynamic> toJson() => {
    'Id': Id,
    'DriverId': driverID,
    'Address': address,
    'City': city,
    'FirstName': firstName,
    'LastName': lastName,
    'Latitude': latitude,
    'Longitude': longitude,
    'Schedule': schedule,
    'Notes': notes,
    'OrgId': orgId
  };

  getID() {
    return Id;
  }

  getDriverId() {
    return driverID;
  }

  getAddress() {
    return address;
  }

  getCity() {
    return city;
  }

  getFirstName() {
    return firstName;
  }

  getLastName() {
    return lastName;
  }

  getLatitude() {
    return latitude;
  }

  getLongitude() {
    return longitude;
  }

  getSchedule() {
    return schedule;
  }

  getNotes() {
    return notes;
  }

  getOrgId() {
    return orgId;
  }
}