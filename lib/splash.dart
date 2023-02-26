import 'package:doctor_prescription/constants.dart';
import 'package:doctor_prescription/models/models.dart';
import 'package:doctor_prescription/provider/provider_services.dart';
import 'package:doctor_prescription/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool _isLoggedIn = false;
  bool _showSplash = false;

  checkLogin() {
    _showSplash = true;
    Future.delayed(
        const Duration(
          seconds: 3,
        ), () {
      if (Provider.of<FirebaseServices>(context, listen: false).isLoggedIn()) {
        if (Provider.of<FirebaseServices>(context, listen: false).getUserType() == USER_TYPE_PATIENT) {
          Navigator.of(context).pushReplacementNamed(PATIENT_DASHBOARD);
        } else {
          Navigator.of(context).pushReplacementNamed(DOCTOR_DASHBOARD);
        }
      } else {
        Navigator.of(context).pushReplacementNamed(LOGIN);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: 'prescription',
                  child: AnimatedOpacity(
                    opacity: _showSplash ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Image.asset(
                      'assets/icons/note.png',
                      height: 256.0,
                      width: 256.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                AnimatedOpacity(
                  opacity: _showSplash ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    'Doctor\'s Prescription',
                    style: GoogleFonts.poppins(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  opacity: _isLoggedIn ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 50.0),
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
