class PersonalInfo {
  final String? name;
  final String? email;
  final String? workAt;
  final String? mobileNumber;

  PersonalInfo({
    this.name,
    this.email,
    this.workAt,
    this.mobileNumber,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'] as String?,
      email: json['email'] as String?,
      workAt: json['workat'] as String?,
      mobileNumber: json['mobile_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'workat': workAt,
      'mobile_number': mobileNumber,
    };
  }
}
