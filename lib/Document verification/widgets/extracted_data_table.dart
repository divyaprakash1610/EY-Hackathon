import 'package:flutter/material.dart';

class ExtractedDataTable extends StatelessWidget {
  final Map<String, String> extractedText;

  const ExtractedDataTable({Key? key, required this.extractedText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Field')),
        DataColumn(label: Text('Value')),
      ],
      rows: extractedText.entries.map((entry) {
        return DataRow(cells: [
          DataCell(Text(entry.key)),
          DataCell(Text(entry.value)),
        ]);
      }).toList(),
    );
  }
}
