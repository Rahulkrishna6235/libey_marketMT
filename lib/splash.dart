import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:libey_mt/utilities/colors.dart';
import 'package:libey_mt/views/login/loginscreen.dart';
import 'package:libey_mt/views/register/registerscreen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Loginscreeen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorControllers().appbarcolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 200,
                height: 200,
                child: Text("E COMMERCE",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
            const SizedBox(
              height: 30,
            ),
            if (Platform.isAndroid)
              const CupertinoActivityIndicator(
                radius: 20,
              )
            else
              const CircularProgressIndicator(
                color: Colors.white,
              )
          ],
        ),
      ),
    );
  }
}
