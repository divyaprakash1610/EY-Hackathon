import 'package:ey_hackathon/Azure%20connection/retrieveFromAzure.dart';
import 'package:flutter/material.dart';
import 'package:ey_hackathon/Document%20verification/widgets/scheme_cart.dart';

class SchemesPage extends StatefulWidget {
  const SchemesPage({Key? key}) : super(key: key);

  @override
  State<SchemesPage> createState() => _SchemesPageState();
}

class _SchemesPageState extends State<SchemesPage> {
  TextEditingController _aadharController = TextEditingController();
  Map<String, dynamic>? userData;
  bool _isLoading = false;

  // Fetch user details from Azure Blob Storage using Aadhar number
  Future<void> fetchUserData(String aadharNumber) async {
    setState(() {
      _isLoading = true;
    });

    final data =
        await fetchUserDataFromAzure(aadharNumber); // Call the Azure function

    setState(() {
      userData = data;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _aadharController
        .dispose(); // Dispose of the controller when widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recommended Schemes"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input text field for Aadhar number
            TextField(
              controller: _aadharController,
              decoration: InputDecoration(
                labelText: "Enter Aadhar Number",
                border: OutlineInputBorder(),
                hintText: "XXXX-XXXX-XXXX",
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),

            // Button to fetch user data
            ElevatedButton(
              onPressed: () {
                final aadharNumber = _aadharController.text;
                if (aadharNumber.isNotEmpty) {
                  fetchUserData(
                      aadharNumber); // Fetch data with the entered Aadhar number
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Please enter a valid Aadhar number.")),
                  );
                }
              },
              child: Text("Get Recommendations"),
            ),

            SizedBox(height: 20),

            // Show loading indicator if data is being fetched
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : userData == null
                    ? Center(
                        child:
                            Text("Enter Aadhar number to get recommendations"))
                    : Expanded(
                        child: ListView.builder(
                          itemCount:
                              (userData!['recommended_schemes'] as List).length,
                          itemBuilder: (context, index) {
                            final scheme =
                                userData!['recommended_schemes'][index];
                            return SchemeCard(
                                scheme: scheme); // Display scheme data
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
