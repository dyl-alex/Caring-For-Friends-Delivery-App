class Organization {
  final String organizationId;
  final String organizationName;
  final String icon;
  final String thumbnail;
  final String joinCode;

  const Organization ({
    required this.organizationId,
    required this.organizationName,
    required this.icon,
    required this.thumbnail,
    required this.joinCode
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      organizationId: json['OrganizationId'] as String,
      organizationName: json['OrganizationName'] as String,
      icon: json['Icon'] as String,
      thumbnail: json['Thumbnail'] as String,
      joinCode: json['JoinCode'] as String
    );
  }
  Map<String, dynamic> toJson() => {
    'OrganizationId': organizationId,
    'OrganizationName': organizationName,
    'Icon': icon,
    'Thumbnail': thumbnail,
    'JoinCode': joinCode
  };

  getOrgID() {
    return organizationId;
  }

  getOrgName() {
    return organizationName;
  }

  getOrgIcon() {
    return icon;
  }

  getOrgThumbnail() {
    return thumbnail;
  }
  getOrgCode() {
    return joinCode;
  }
}