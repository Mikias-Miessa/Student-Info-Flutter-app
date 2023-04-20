import 'package:flutter/material.dart';

class ResultTable extends StatelessWidget {
  final TextStyle style;
  final String cell1;
  final String cell2;
  final String cell3;

  ResultTable(
      {required this.style,
      required this.cell1,
      required this.cell2,
      required this.cell3});
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.blue, width: 3),
      children: [
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Text(
                cell1,
                style: style,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Text(
                cell2,
                style: style,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Text(
                cell3,
                style: style,
              ),
            )
          ],
        )
      ],
    );
  }
}
