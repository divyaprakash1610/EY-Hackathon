import 'dart:convert';
import 'package:http/http.dart' as http;

// Function to fetch user data from Azure Blob Storage
Future<Map<String, dynamic>?> fetchUserDataFromAzure(
    String aadharNumber) async {
  try {
    final url =
        'https://<your-azure-blob-storage-url>/user-details/$aadharNumber.json'; // Replace with your Azure Blob Storage URL

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse and return the user data
      return jsonDecode(response.body);
    } else {
      print("Error fetching user data: ${response.body}");
      return null;
    }
  } catch (e) {
    print("Error fetching data from Azure: $e");
    return null;
  }
}
