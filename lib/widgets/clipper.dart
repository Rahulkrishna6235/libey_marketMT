

import 'package:flutter/material.dart';

Widget myclipper() {
  return Stack(
    children: [
      Opacity(
        opacity: 0.7,
        child: ClipPath(
          clipper: MyCustomClipper(),
          child: Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color(0xFFC333B5),
                  Color(0xFFCF75D2),
                  Color(0xFFF3E4F5),
                ])),
          ),
        ),
      ),
      Stack(
        children: [
          Positioned(
            child: Container(
              width: 300,
              height: 175,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(70),
                ),
                color: Color(0xFFCF75D2),
              ),
            ),
          ),
          Positioned(
            child: Container(
              width: 200,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(40),
                ),
                color: Color(0xFFC272BA),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height * 0.75);

    path.quadraticBezierTo(size.width * 0.27, size.height * 0.5,
        size.width * 0.5, size.height * 0.75);

    path.quadraticBezierTo(
        size.width * 0.75, size.height * 1, size.width, size.height * 0.75);

    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
