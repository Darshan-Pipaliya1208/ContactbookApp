import 'package:flutter/material.dart';
import 'package:practicalexam/SignIn.dart';
import 'package:practicalexam/afterLoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstLogo extends StatefulWidget {
  static SharedPreferences? prefs;

  @override
  State<FirstLogo> createState() => _FirstLogoState();
}

class _FirstLogoState extends State<FirstLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  getSharepreference() async {
    FirstLogo.prefs = await SharedPreferences.getInstance();
    setState(() {});
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    animationController.forward();

    Future.delayed(Duration(seconds: 3), () {
      bool islogin = FirstLogo.prefs!.getBool("loginstatus") ?? false;

      if (islogin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => afterLoginPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getSharepreference();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo-no-background 1.png'),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 20,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
