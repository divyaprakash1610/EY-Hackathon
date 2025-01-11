import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

Future<Map<String, String>> extractDetailsFromImage(File imageFile) async {
  final inputImage = InputImage.fromFile(imageFile);
  final textRecognizer = GoogleMlKit.vision.textRecognizer();
  StringBuffer extractedText = StringBuffer();

  Map<String, String> extractedData = {
    'aadhar_number': '',
    'name': '',
    'father_name': '',
    'dob': '',
    'vtc': '',
    'po': '',
    'sub_district': '',
    'district': '',
    'state': '',
    'pin_code': '',
    'mobile': '',
    'gender': '',
  };

  try {
    final recognizedText = await textRecognizer.processImage(inputImage);

    // Combine the extracted text into one string for easier processing
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        extractedText.writeln(line.text);
      }
    }

    String text = extractedText.toString();
    // Use regex to extract specific details

    // Extract Name (below "To")
    RegExp nameRegExp = RegExp(r'To\n([A-Za-z\s]+)(?=\n|$)');
    extractedData['name'] = nameRegExp.firstMatch(text)?.group(1) ?? '';

    // Extract Father's Name (after "D/O" or "S/O")
    RegExp fatherNameRegExp = RegExp(r'(D/O|S/O):\s?([A-Za-z\s]+)');
    extractedData['father_name'] =
        fatherNameRegExp.firstMatch(text)?.group(2) ?? '';

    // Extract DOB (Date of Birth, format DD/MM/YYYY)
    RegExp dobRegExp = RegExp(r'DOB:\s?(\d{2}/\d{2}/\d{4})');
    extractedData['dob'] = dobRegExp.firstMatch(text)?.group(1) ?? '';

    // Extract Address fields (VTC, PO, Sub District, District, State, PIN Code)
    RegExp vtcRegExp = RegExp(r'VTC:\s?([A-Za-z\s]+)');
    extractedData['vtc'] = vtcRegExp.firstMatch(text)?.group(1) ?? '';

    RegExp poRegExp = RegExp(r'PO:\s?([A-Za-z\s]+)');
    extractedData['po'] = poRegExp.firstMatch(text)?.group(1) ?? '';

    RegExp subDistrictRegExp = RegExp(r'Sub District:\s?([A-Za-z\s]+)');
    extractedData['sub_district'] =
        subDistrictRegExp.firstMatch(text)?.group(1) ?? '';

    RegExp districtRegExp = RegExp(r', District:\s?([A-Za-z\s]+)');
    extractedData['district'] = districtRegExp.firstMatch(text)?.group(1) ?? '';

    RegExp stateRegExp = RegExp(r'State:\s?([A-Za-z\s]+)');
    extractedData['state'] = stateRegExp.firstMatch(text)?.group(1) ?? '';

    RegExp pinCodeRegExp = RegExp(r'PIN Code:\s?(\d{6})');
    extractedData['pin_code'] = pinCodeRegExp.firstMatch(text)?.group(1) ?? '';

    // Extract Mobile Number (10 digits)
    RegExp mobileRegExp = RegExp(r'Mobile:\s?(\d{10})');
    extractedData['mobile'] = mobileRegExp.firstMatch(text)?.group(1) ?? '';

    // Extract Gender (Male, Female, etc.)
    RegExp genderRegExp = RegExp(r'(Male|Female)');
    extractedData['gender'] = genderRegExp.firstMatch(text)?.group(1) ?? '';

    // Extract Aadhar Number (12-digit number)
    RegExp aadharRegExp =
        RegExp(r'Your Aadhaar No. :\n\s?(\d{4}\s?\d{4}\s?\d{4})');
    extractedData['aadhar_number'] =
        aadharRegExp.firstMatch(text)?.group(1) ?? '';
  } catch (e) {
    print("Error extracting text: $e");
  } finally {
    textRecognizer.close();
  }

  return extractedData;
}
