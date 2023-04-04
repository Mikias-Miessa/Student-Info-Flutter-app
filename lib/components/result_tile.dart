import 'package:flutter/material.dart';

class ResultTile extends StatelessWidget {
  String? Subject;
  String? Result;
  ResultTile({required this.Subject, required this.Result});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        right: 40,
        left: 40,
      ),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
                bottomLeft: Radius.circular(7),
                bottomRight: Radius.circular(7)),
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                blurStyle: BlurStyle.outer,
                color: Colors.grey,
                // spreadRadius: 3,
                offset: Offset(2, 2),
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 30,
              ),
              child: Text(
                '$Subject',
                style: TextStyle(
                    color: Color(0xffffa500),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 30,
              ),
              child: Text(
                '$Result',
                style: TextStyle(
                    color: Color(0xff1f75fe),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
