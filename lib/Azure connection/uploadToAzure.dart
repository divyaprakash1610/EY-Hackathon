import 'dart:convert';

import 'package:azblob/azblob.dart';
import 'dart:io';

String connectionString =
    'DefaultEndpointsProtocol=https;AccountName=flutterappey;AccountKey=UqK9Fd34fmkiGYXVAI+cwu0gB7LlPPlHJcywm+t2vxqXAH4A0af73NUtcjWNUoLF4rAPY/GU79p/+ASt84W75g==;EndpointSuffix=core.windows.net';

Future<void> uploadToAzureBlob(File imageFile, String BlobName) async {
  final azureStorage = AzureStorage.parse(connectionString);
  try {
    // Read image bytes
    final imageBytes = await imageFile.readAsBytes();
    // Upload the image to Azure Blob Storage in the 'ocr-images' container
    await azureStorage.putBlob('/ocr-images/$BlobName',
        bodyBytes: imageBytes, contentType: 'image/jpeg');
    print('Image uploaded successfully');
  } catch (e) {
    print('Failed to upload image: $e');
  }
}

Future<void> uploadUserData(
    Map<String, dynamic>? userDetails, String blobName) async {
  // Convert user details map to JSON string
  String jsonData = json.encode(userDetails);

  try {
    // Create an instance of Azure Storage Blob
    final storage = AzureStorage.parse(connectionString);
    // Upload the data to Azure Blob Storage in the 'user-details' container
    await storage.putBlob(
      'user-details/$blobName', // container name
      bodyBytes: utf8.encode(jsonData), // content
      contentType: 'application/json', // content type
    );
    print('Data uploaded successfully to Blob Storage');
  } catch (e) {
    print('Error uploading data: $e');
  }
}
