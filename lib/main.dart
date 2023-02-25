import 'package:camera/camera.dart';
import 'package:doctor_prescription/pages/auth/login.dart';
import 'package:doctor_prescription/pages/auth/registration.dart';
import 'package:doctor_prescription/pages/doctor/add_patient/scan_qr.dart';
import 'package:doctor_prescription/pages/doctor/add_patient/scan_result.dart';
import 'package:doctor_prescription/pages/doctor/dashboard.dart';
import 'package:doctor_prescription/pages/patient/dashboard_patient.dart';
import 'package:doctor_prescription/pages/patient/scan_prescription.dart';
import 'package:doctor_prescription/pages/patient/showQR.dart';
import 'package:doctor_prescription/routes.dart';
import 'package:doctor_prescription/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

List<CameraDescription>? cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor Prescribe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: SPLASH,
      routes: {
        SPLASH: (context) => SplashScreenPage(),
        LOGIN: (context) => LoginPage(),
        REGISTER: (context) => Registration(),
        PATIENT_DASHBOARD: (context) => PatientDashboard(),
        PATIENT_SCAN_PRESCRIPTION: (context) => PatientScanPrescription(),
        // PATIENT_ADD_MEDICINE: (context) => PatientAddMedicine(),
        // PATIENT_PRESCRIPTION_SCAN: (context) => PrescriptionScan(),
        PATIENT_SHOW_QR: (context) => QrCodePage(),
        // DOCTOR ROUTES
        DOCTOR_DASHBOARD: (context) => DoctorDashboard(),
        DOCTOR_SCAN_QR: (context) => ScanQRPage(),
        DOCTOR_SCAN_RESULT: (context) => ScanResultPage(),
      },
    );
  }
}
