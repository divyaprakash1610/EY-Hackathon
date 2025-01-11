import 'package:ey_hackathon/Azure%20connection/uploadToAzure.dart';
import 'package:ey_hackathon/Document%20verification/Functions/extract_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  Future<void> pickAndProcessImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _selectedImage = imageFile;
        _isImageProcessed = false;
      });

      Map<String, String> extractedData =
          await extractDetailsFromImage(imageFile);

      setState(() {
        _extractedText = extractedData;
        _isImageProcessed = true;
      });

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
        title: Text("Upload document"),
      ),
      body: Padding(
        padding: EdgeInsets.all(screen_width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: pickAndProcessImage,
                child: Text('Pick Image and Extract Text',
                    style: TextStyle(fontSize: screen_width * 0.045)),
              ),
            ),
            SizedBox(height: screen_height * 0.02),
            _selectedImage != null
                ? Container(
                    height: screen_height * 0.3,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Image.file(_selectedImage!, fit: BoxFit.cover),
                  )
                : Center(
                    child: Text('No image selected.',
                        style: TextStyle(fontSize: screen_width * 0.04))),
            SizedBox(height: screen_height * 0.03),
            _isImageProcessed
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Extracted Text:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screen_width * 0.05)),
                      SizedBox(height: screen_height * 0.01),
                      Text("Aadhar Number: ${_extractedText['aadhar_number']}"),
                      Text("Name: ${_extractedText['name']}"),
                      Text("Father Name: ${_extractedText['father_name']}"),
                      Text("DOB: ${_extractedText['dob']}"),
                      Text("Gender: ${_extractedText['gender']}"),
                      Text("Mobile: ${_extractedText['mobile']}"),
                      Text("VTC: ${_extractedText['vtc']}"),
                      Text("PO: ${_extractedText['po']}"),
                      Text("Sub District: ${_extractedText['sub_district']}"),
                      Text("District: ${_extractedText['district']}"),
                      Text("State: ${_extractedText['state']}"),
                      Text("PIN Code: ${_extractedText['pin_code']}"),

                      SizedBox(height: screen_height * 0.03),

                      // Submit Button to upload user data
                      ElevatedButton(
                        onPressed: () {
                          uploadUserData(_extractedText);
                        },
                        child: Text('Submit User Details'),
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }
}
