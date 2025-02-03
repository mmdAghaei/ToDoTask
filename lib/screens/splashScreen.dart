import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todotask/screens/home.dart';
import 'package:todotask/utils/color.dart';
import 'package:todotask/utils/fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> init() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Task",
              style: TextStyle(
                  fontSize: 300.w,
                  fontFamily: Fonts.HandWrite.fontFamily,
                  color: pink,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
