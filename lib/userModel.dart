class Scheme {
  final String name;
  final String description;
  final String applicationLink;
  final String benefits;
  final String deadline;
  final String schemeId;

  Scheme({
    required this.name,
    required this.description,
    required this.applicationLink,
    required this.benefits,
    required this.deadline,
    required this.schemeId,
  });

  // To create a Scheme object from JSON
  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      applicationLink: json['application_link'] ?? '',
      benefits: json['benefits'] ?? '',
      deadline: json['deadline'] ?? '',
      schemeId: json['scheme_id'] ?? 0,
    );
  }
  factory Scheme.fromMap(Map<String, dynamic> map) {
    return Scheme(
      schemeId: map['scheme_id'],
      name: map['name'],
      description: map['description'],
      benefits: map['benefits'],
      applicationLink: map['application_link'],
      deadline: map['deadline'],
    );
  }
  String toString() {
    return 'Scheme(name: $name, schemeId: $schemeId, description: $description, benefits: $benefits, applicationLink: $applicationLink, deadline: $deadline)';
  }

  // To convert Scheme object to JSON (for sending to backend or saving)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'application_link': applicationLink,
      'benefits': benefits,
      'deadline': deadline,
      'scheme_id': schemeId,
    };
  }
}

class UserDetails {
  String aadharNumber;
  String name;
  String fatherName;
  String dob;
  List<Scheme> recommendedSchemes; // Add recommended_schemes
  String vtc;
  String po;
  String subDistrict;
  String district;
  String state;
  String pinCode;
  String mobile;
  String gender;

  UserDetails({
    required this.aadharNumber,
    required this.name,
    required this.fatherName,
    required this.dob,
    required this.recommendedSchemes,
    required this.vtc,
    required this.po,
    required this.subDistrict,
    required this.district,
    required this.state,
    required this.pinCode,
    required this.mobile,
    required this.gender,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    var schemeList = (json['recommended_schemes'] as List)
        .map((scheme) => Scheme.fromJson(scheme as Map<String, dynamic>))
        .toList();

    return UserDetails(
      aadharNumber: json['aadhar_number'] ?? '',
      name: json['name'] ?? '',
      fatherName: json['father_name'] ?? '',
      dob: json['dob'] ?? '',
      vtc: json['vtc'] ?? '',
      po: json['po'] ?? '',
      subDistrict: json['sub_district'] ?? '',
      district: json['district'] ?? '',
      state: json['state'] ?? '',
      pinCode: json['pin_code'] ?? '',
      mobile: json['mobile'] ?? '',
      gender: json['gender'] ?? '',
      recommendedSchemes: schemeList, // Correctly parsed list of Scheme objects
    );
  }

  // Fix: Changing return type to Map<String, dynamic> to include complex types (like List)
  Map<String, dynamic> toJson() {
    return {
      'aadhar_number': aadharNumber,
      'name': name,
      'father_name': fatherName,
      'dob': dob,
      'vtc': vtc,
      'po': po,
      'sub_district': subDistrict,
      'district': district,
      'state': state,
      'pin_code': pinCode,
      'mobile': mobile,
      'gender': gender,
      'recommended_schemes': recommendedSchemes
          .map((scheme) => scheme.toJson())
          .toList(), // Convert schemes to JSON
    };
  }
}
