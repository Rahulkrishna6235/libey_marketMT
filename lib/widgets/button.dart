import 'package:flutter/material.dart';
import 'package:libey_mt/utilities/colors.dart';

Widget Button(String txt){
return Container(
      width: 290,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFFF6EAF6),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorControllers().ElevatedButtoncolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed:(){},
        child: Text(
                "$txt",
                style: TextStyle(
                  fontSize: 20,
                  color: ColorControllers().textcolor,
                ),
              ),
      ),
    );
}