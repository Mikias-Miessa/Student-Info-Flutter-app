import 'package:flutter/material.dart';

class ThreeInputCard extends StatelessWidget {
  String text1;
  String text2;
  String text3;

  ThreeInputCard(
      {required this.text1, required this.text2, required this.text3});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              text1,
              style: TextStyle(
                  color: Color(0xffffa500),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Text(
              text2,
              style: TextStyle(
                  color: Color(0xffffa500),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35.0),
            child: Text(
              text3,
              style: TextStyle(
                  color: Color(0xffffa500),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
