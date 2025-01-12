import 'package:flutter/material.dart';

class SchemeCard extends StatelessWidget {
  final Map<String, dynamic> scheme;

  const SchemeCard({Key? key, required this.scheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title:
            Text(scheme['name'], style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Scheme ID: ${scheme['scheme_id']}"),
            Text("Description: ${scheme['description']}"),
            Text("Benefits: ${scheme['benefits']}"),
            Text("Application Link: ${scheme['application_link']}"),
            Text("Deadline: ${scheme['deadline']}"),
          ],
        ),
        tileColor: const Color.fromARGB(255, 251, 222, 136),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.all(10),
      ),
    );
  }
}
