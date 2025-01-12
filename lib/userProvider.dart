import 'package:flutter/material.dart';
import 'userModel.dart';

class UserDetailsProvider with ChangeNotifier {
  // Initializing with an empty list for recommendedSchemes
  UserDetails _userDetails = UserDetails(
    aadharNumber: '',
    name: '',
    fatherName: '',
    dob: '',
    vtc: '',
    po: '',
    recommendedSchemes: [], // List of Scheme objects
    subDistrict: '',
    district: '',
    state: '',
    pinCode: '',
    mobile: '',
    gender: '',
  );

  UserDetails get userDetails => _userDetails;

  // Setting UserDetails with a UserDetails object
  void setUserDetails(UserDetails userDetails) {
    _userDetails = userDetails;
    notifyListeners();
  }

  // Updating individual fields in UserDetails
  void updateField(String field, String value) {
    switch (field) {
      case 'aadhar_number':
        _userDetails.aadharNumber = value;
        break;
      case 'name':
        _userDetails.name = value;
        break;
      case 'father_name':
        _userDetails.fatherName = value;
        break;
      case 'dob':
        _userDetails.dob = value;
        break;
      case 'vtc':
        _userDetails.vtc = value;
        break;
      case 'po':
        _userDetails.po = value;
        break;
      case 'sub_district':
        _userDetails.subDistrict = value;
        break;
      case 'district':
        _userDetails.district = value;
        break;
      case 'state':
        _userDetails.state = value;
        break;
      case 'pin_code':
        _userDetails.pinCode = value;
        break;
      case 'mobile':
        _userDetails.mobile = value;
        break;
      case 'gender':
        _userDetails.gender = value;
        break;
    }
    notifyListeners();
  }

  // Method to add a new scheme to the recommendedSchemes list
  void addScheme(Scheme scheme) {
    _userDetails.recommendedSchemes.add(scheme);
    notifyListeners();
  }

  // Method to remove a scheme from the recommendedSchemes list
  void removeScheme(int schemeId) {
    _userDetails.recommendedSchemes
        .removeWhere((scheme) => scheme.schemeId == schemeId);
    notifyListeners();
  }
}
