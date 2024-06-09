class recipient {
  final int id;
  final String firstName;
  final String lastName;
  final String Address;
  final String City;
  final int frequency;
  final String Driver;
  final String Notes;
  recipient(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.Address,
      required this.City,
      required this.Driver,
      required this.frequency,
      required this.Notes});

  factory recipient.fromMap(Map<String, dynamic> json) => recipient(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      Address: json['Address'],
      City: json['City'],
      Driver: json['Driver'],
      frequency: json['frequency'],
      Notes: json['Notes']);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'Address': Address,
      'City': City,
      'frequency': frequency,
      'Driver': Driver,
      'Notes': Notes
    };
  }
}
