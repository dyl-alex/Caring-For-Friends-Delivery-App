class Delivery {
  final String id;
  final String driverId;
  final String recipientId;
  final DateTime date;

  const Delivery ({
    required this.id,
    required this.recipientId,
    required this.date,
    required this.driverId
});

  factory Delivery.fromJson(Map<String, dynamic> json) {
    String tempId = "";
    if (json['DriverId'] == null) {
      tempId = "";
    } else {
      tempId = json['DriverId'];
    }

    DateTime tempDate = DateTime.parse(json['Date']);

    return Delivery(
        id: json['Id'] as String,
        driverId: tempId,
        recipientId: json['RecipientId'] as String,
        date: tempDate
    );
  }

  Map<String, dynamic> toJson() => {
    'Id': id,
    'DriverId': driverId,
    'RecipientId': recipientId,
    'Date': date.toIso8601String()
  };

  getRecipientID() {
    return recipientId;
  }
}