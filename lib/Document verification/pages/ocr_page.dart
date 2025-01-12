import 'package:ey_hackathon/Azure%20connection/uploadToAzure.dart';
import 'package:ey_hackathon/Document%20verification/Functions/extract_text.dart';
import 'package:ey_hackathon/Document%20verification/widgets/extracted_data_table.dart';
import 'package:ey_hackathon/Document%20verification/widgets/scheme_cart.dart';
import 'package:ey_hackathon/userModel.dart';
import 'package:ey_hackathon/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class OcrPage extends StatefulWidget {
  const OcrPage({super.key});

  @override
  State<OcrPage> createState() => _OcrPageState();
}

class _OcrPageState extends State<OcrPage> {
  Map<String, String> _extractedText = {
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
  File? _selectedImage;
  bool _isImageProcessed = false;
  Map<String, dynamic>? _userData;

  Future<void> fetchUserData(Map<String, dynamic> _userData) async {
    String userDataJson = jsonEncode(_userData);

    final url =
        'http://192.168.0.186:5000/get_user_data?user_data=$userDataJson';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          this._userData = data; // Update userData
          print("Updated _userData: $_userData"); // Print userData
        });
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // Future<void> submitData(BuildContext context) async {

  //               // Create User object
  //               UserDetails newUser = UserDetails(
  //                 aadharNumber: aadharController.text,
  //                 name: ,
  //                 fatherName: 'Father Name',
  //                 dob: 'DOB',
  //                 vtc: 'VTC',
  //                 po: 'PO',
  //                 subDistrict: 'Sub District',
  //                 district: 'District',
  //                 state: 'State',
  //                 pinCode: 'PIN Code',
  //                 mobile: 'Mobile',
  //                 gender: 'Gender',
  //               );

  //               // Update user data in the provider
  //               Provider.of<UserDetailsProvider>(context, listen: false)
  //                   .updateUser(newUser);
  // }

  // Pick image and process it using OCR
  Future<void> pickAndProcessImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _selectedImage = imageFile;
        _isImageProcessed = false;
      });

      // Assuming extractDetailsFromImage is a function that extracts text from the image
      Map<String, String> extractedData =
          await extractDetailsFromImage(imageFile);

      setState(() {
        _extractedText = extractedData;
        _isImageProcessed = true;
      });

      // Optionally upload image to Azure
      await uploadToAzureBlob(imageFile,
          'uploaded-image-${DateTime.now().millisecondsSinceEpoch}.jpg');
    } else {
      print("No image selected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 244, 206, 92), // Set your app bar color
        title: Text("Upload Document"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screen_width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/verification.png",
                  height: screen_height * 0.1),
              SizedBox(height: screen_height * 0.02),
              // Button to pick and process image with a larger size and color change
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: pickAndProcessImage,
                  style: ElevatedButton.styleFrom(
                    // Button color change
                    backgroundColor: const Color.fromARGB(255, 244, 206, 92),
                    padding:
                        EdgeInsets.symmetric(vertical: screen_height * 0.03),
                    textStyle: TextStyle(fontSize: screen_width * 0.05),
                  ),
                  child: Text(
                    'Upload your document as image',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: screen_height * 0.02),

              // Display selected image
              _selectedImage != null
                  ? Container(
                      height: screen_height * 0.3,
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Image.file(_selectedImage!, fit: BoxFit.cover),
                    )
                  : Center(
                      child: Text('No image selected.',
                          style: TextStyle(
                              fontSize: screen_width * 0.04,
                              color: Colors.black))),
              SizedBox(height: screen_height * 0.03),

              // Display extracted text in a table if processed
              _isImageProcessed
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Extracted Text:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screen_width * 0.05)),
                        SizedBox(height: screen_height * 0.01),
                        ExtractedDataTable(extractedText: _extractedText),

                        SizedBox(height: screen_height * 0.03),

                        // Submit Button to upload user data
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                // Button color change

                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(
                                    vertical: screen_height * 0.02,
                                    horizontal: screen_height * 0.02),
                                textStyle:
                                    TextStyle(fontSize: screen_width * 0.05),
                              ),
                              child: Text(
                                'Verify Details',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await fetchUserData(_extractedText);

                                uploadUserData(_userData,
                                    '${_extractedText['aadhar_number']}.json');
                              },
                              style: ElevatedButton.styleFrom(
                                // Button color change

                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(
                                    vertical: screen_height * 0.02,
                                    horizontal: screen_height * 0.02),
                                textStyle:
                                    TextStyle(fontSize: screen_width * 0.05),
                              ),
                              child: Text(
                                'Scheme Recommendations',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),

              SizedBox(height: screen_height * 0.03),

              // Display recommendations if available
              _userData != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Recommended Schemes:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screen_width * 0.05)),
                        ...(_userData!['recommended_schemes'] as List)
                            .map((scheme) {
                          return SchemeCard(scheme: scheme);
                        }).toList(),
                      ],
                    )
                  : Container(
                      child: Text("No recommendations found"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
