class Driver {
  final int id;
  final String name;
  final String phone;
  Driver({required this.id, required this.name, required this.phone});

  factory Driver.fromMap(Map<String, dynamic> json) =>
       Driver(id: json['id'], name: json['name'], phone: json['phone']);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }
}
